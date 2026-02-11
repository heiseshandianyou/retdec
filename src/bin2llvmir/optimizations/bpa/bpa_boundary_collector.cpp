/**
* @file src/bin2llvmir/optimizations/bpa/bpa_boundary_collector.cpp
* @brief BPA Step 1: Collect stack boundary candidates
* 
* This pass collects candidate values for stack variable boundaries
* without modifying LLVM IR. It is the first step of BPA.
*/

#include <capstone/x86.h>

#define debug_enabled false

#include <llvm/IR/Constants.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Operator.h>
#include <llvm/Support/raw_ostream.h>

#include "retdec/bin2llvmir/analyses/reaching_definitions.h"
#include "retdec/bin2llvmir/optimizations/bpa/bpa_boundary_collector.h"
#include "retdec/bin2llvmir/providers/asm_instruction.h"
#include "retdec/bin2llvmir/utils/llvm.h"

using namespace llvm;

namespace retdec {
namespace bin2llvmir {

char BPABoundaryCollector::ID = 0;

static RegisterPass<BPABoundaryCollector> X(
		"retdec-bpa-boundary-collector",
		"BPA Step 1: Collect stack boundary candidates (read-only)",
		false,  // Is analysis pass
		true    // Is read-only
);

BPABoundaryCollector::BPABoundaryCollector() :
		ModulePass(ID)
{
}

bool BPABoundaryCollector::runOnModule(llvm::Module& m)
{
	_module = &m;
	_config = ConfigProvider::getConfig(_module);
	_abi = AbiProvider::getAbi(_module);
	return run();
}

bool BPABoundaryCollector::runOnModuleCustom(
		llvm::Module& m,
		Config* c,
		Abi* abi)
{
	_module = &m;
	_config = c;
	_abi = abi;
	return run();
}

bool BPABoundaryCollector::run()
{
	if (_config == nullptr)
	{
		return false;
	}

	LOG << "=== BPA Boundary Collector Starting ===" << std::endl;

	// Process each function
	for (auto& f : *_module)
	{
		if (f.isDeclaration())
		{
			continue;
		}

		auto info = analyzeFunction(f);
		if (!info.topRelativeOffsets.empty())
		{
			_boundaryInfos.push_back(info);
		}
	}

	// Print report
	printBoundaryReport(llvm::errs());

	LOG << "=== BPA Boundary Collector Complete ===" << std::endl;

	// This is an analysis pass - does not modify IR
	return false;
}

StackBoundaryInfo BPABoundaryCollector::analyzeFunction(llvm::Function& f)
{
	StackBoundaryInfo info;
	info.functionName = f.getName().str();
	
	// Get function address from config if available
	if (_config)
	{
		info.functionAddress = _config->getFunctionAddress(&f);
	}

	// Track current RSP offset relative to top during analysis
	// At function entry: RSP = top, offset = 0
	int64_t currentRSPOffset = 0;
	int64_t rbpToTopOffset = -8;  // rbp = top - 8 (standard frame)
	
	// Track dynamic stack regions (VLA, alloca)
	// Key: region ID, Value: base offset from top
	std::map<int, int64_t> dynamicRegionBases;
	int nextRegionId = 0;

	LOG << "Analyzing function: " << info.functionName << std::endl;

	ReachingDefinitionsAnalysis RDA;
	RDA.runOnModule(*_module, _abi);

	// First pass: identify dynamic stack allocations (sub rsp / alloca patterns)
	for (auto& bb : f)
	{
		for (auto& inst : bb)
		{
			// Look for RSP modifications that indicate dynamic allocation
			if (auto* store = dyn_cast<StoreInst>(&inst))
			{
				if (_abi->isStackPointerRegister(store->getPointerOperand()))
				{
					// RSP is being modified
					// Try to compute the change
					auto root = SymbolicTree::OnDemandRda(store->getValueOperand());
					auto offsetRes = calculateLinearOffset(&root);
					
					if (offsetRes && offsetRes->second)
					{
						// This might be a dynamic allocation
						// For simplicity, we track significant RSP changes
						if (offsetRes->first < -8)  // Larger than a single push
						{
							DynamicStackRegion region;
							region.id = nextRegionId++;
							region.baseOffsetFromTop = offsetRes->first;
							region.size = 0;  // Unknown size
							region.allocInstruction = &inst;
							region.description = "Dynamic alloc at offset " + std::to_string(offsetRes->first);
							info.dynamicRegions.push_back(region);
							dynamicRegionBases[region.id] = region.baseOffsetFromTop;
						}
					}
				}
			}
		}
	}

	// Second pass: collect all stack accesses
	for (auto& bb : f)
	{
		for (auto& inst : bb)
		{
			// Look for load/store that might be stack accesses
			Value* pointerOperand = nullptr;
			bool isLoad = false;
			
			if (auto* load = dyn_cast<LoadInst>(&inst))
			{
				pointerOperand = load->getPointerOperand();
				isLoad = true;
			}
			else if (auto* store = dyn_cast<StoreInst>(&inst))
			{
				pointerOperand = store->getPointerOperand();
				isLoad = false;
			}

			if (!pointerOperand || isa<GlobalVariable>(pointerOperand))
			{
				continue;
			}

			// Skip LLVM to ASM instructions
			if (AsmInstruction::isLlvmToAsmInstruction(&inst))
			{
				continue;
			}

			// Analyze the pointer operand
			auto root = SymbolicTree::OnDemandRda(pointerOperand);
			
			// Check if this involves stack pointer or base pointer
			bool hasStackReg = false;
			llvm::Value* baseReg = nullptr;
			for (SymbolicTree* n : root.getPostOrder())
			{
				if (isStackRelatedRegister(n->value))
				{
					hasStackReg = true;
					baseReg = n->value;
					break;
				}
			}

			if (!hasStackReg || !baseReg)
			{
				continue;
			}

			info.totalAccesses++;

			// Compute normalized offset
			auto normalizedOffset = getNormalizedOffset(root, rbpToTopOffset);
			
			if (!normalizedOffset.has_value())
			{
				info.unprocessedAccesses++;
				continue;
			}

			int64_t absoluteOffset = normalizedOffset.value();
			info.topRelativeOffsets.insert(absoluteOffset);

			// Create detailed access info
			StackAccessInfo accessInfo;
			accessInfo.instruction = &inst;
			accessInfo.baseRegister = baseReg;
			accessInfo.absoluteOffsetFromTop = absoluteOffset;
			accessInfo.isLoad = isLoad;
			
			// Determine if this belongs to a dynamic region
			accessInfo.dynamicRegionId = -1;  // Static by default
			
			// Check if this access falls within a dynamic region
			for (const auto& region : info.dynamicRegions)
			{
				// Simple heuristic: if absolute offset matches region base or is close
				// In practice, we'd need more sophisticated tracking
				if (absoluteOffset <= region.baseOffsetFromTop && 
				    absoluteOffset > region.baseOffsetFromTop - 256)  // Assume max 256 bytes per region
				{
					accessInfo.dynamicRegionId = region.id;
					accessInfo.relativeOffset = absoluteOffset - region.baseOffsetFromTop;
					info.dynamicRegionAccesses++;
					break;
				}
			}
			
			// If not in dynamic region, relative offset is from top or RBP
			if (accessInfo.dynamicRegionId == -1)
			{
				if (isRBPRegister(baseReg))
				{
					accessInfo.relativeOffset = absoluteOffset - rbpToTopOffset;
					info.rbpBasedOffsets.insert(accessInfo.relativeOffset);
					info.rbpAccesses++;
				}
				else
				{
					accessInfo.relativeOffset = absoluteOffset;
					info.rspBasedOffsets.insert(accessInfo.relativeOffset);
					info.rspAccesses++;
				}
			}
			
			accessInfo.accessType = pointerOperand->getType();
			info.stackAccesses.push_back(accessInfo);
			
			// Group by absolute offset
			info.offsetToAccesses[absoluteOffset].push_back(accessInfo);
		}
	}

	LOG << "  Collected " << info.topRelativeOffsets.size() << " boundary candidates" << std::endl;
	LOG << "  Found " << info.dynamicRegions.size() << " dynamic stack regions" << std::endl;
	
	return info;
}

bool BPABoundaryCollector::isStackRelatedRegister(llvm::Value* val)
{
	// Check if it's a register via ABI
	if (_abi->isStackPointerRegister(val) ||
	    _abi->isRegister(val, X86_REG_RBP) ||
	    _abi->isRegister(val, X86_REG_EBP))
	{
		return true;
	}
	
	// Check if it's a global variable like @rsp, @ebp, @rbp
	if (auto* gv = dyn_cast<GlobalVariable>(val))
	{
		std::string name = gv->getName().str();
		if (name == "rsp" || name == "esp" || name == "sp" ||
		    name == "rbp" || name == "ebp" || name == "bp")
		{
			return true;
		}
	}
	
	// Check if it's a load from a stack register
	if (auto* li = dyn_cast<LoadInst>(val))
	{
		auto* ptr = li->getPointerOperand();
		if (isStackRelatedRegister(ptr))
		{
			return true;
		}
	}
	
	return false;
}

bool BPABoundaryCollector::isRBPRegister(llvm::Value* val)
{
	if (_abi->isRegister(val, X86_REG_RBP) ||
	    _abi->isRegister(val, X86_REG_EBP))
	{
		return true;
	}
	
	if (auto* gv = dyn_cast<GlobalVariable>(val))
	{
		std::string name = gv->getName().str();
		if (name == "rbp" || name == "ebp" || name == "bp")
		{
			return true;
		}
	}
	
	// Check if it's a load from RBP
	if (auto* li = dyn_cast<LoadInst>(val))
	{
		auto* ptr = li->getPointerOperand();
		if (isRBPRegister(ptr))
		{
			return true;
		}
	}
	
	return false;
}

std::optional<int64_t> BPABoundaryCollector::getNormalizedOffset(
		SymbolicTree& root,
		int64_t rbpToTopOffset)
{
	auto res = calculateLinearOffset(&root);
	if (!res || !res->second)
	{
		return std::nullopt;
	}

	int64_t offset = res->first;
	llvm::Value* reg = res->second;

	if (isRBPRegister(reg))
	{
		// [RBP + offset] where RBP = top + rbpToTopOffset
		// Normalized: top + (rbpToTopOffset + offset)
		return rbpToTopOffset + offset;
	}
	else if (isStackRelatedRegister(reg))
	{
		// [RSP + offset] where RSP = top + 0 (at entry)
		// Normalized: top + offset
		return offset;
	}

	return std::nullopt;
}

std::optional<std::pair<int64_t, llvm::Value*>> BPABoundaryCollector::calculateLinearOffset(
		SymbolicTree* node)
{
	if (auto* ci = dyn_cast_or_null<ConstantInt>(node->value))
	{
		return std::make_pair(ci->getSExtValue(), nullptr);
	}
	else if (isStackRelatedRegister(node->value))
	{
		return std::make_pair(0, node->value);
	}
	else if (isa<GlobalVariable>(node->value))
	{
		// Stop at any global variable to prevent expansion
		return std::nullopt;
	}
	else if (isa<AddOperator>(node->value))
	{
		int64_t totalOffset = 0;
		llvm::Value* reg = nullptr;

		for (auto& op : node->ops)
		{
			auto res = calculateLinearOffset(&op);
			if (!res) return std::nullopt;

			totalOffset += res->first;
			if (res->second)
			{
				if (reg && reg != res->second) return std::nullopt;
				reg = res->second;
			}
		}
		return std::make_pair(totalOffset, reg);
	}
	else if (isa<SubOperator>(node->value))
	{
		if (node->ops.size() != 2) return std::nullopt;

		auto lhs = calculateLinearOffset(&node->ops[0]);
		auto rhs = calculateLinearOffset(&node->ops[1]);

		if (!lhs || !rhs) return std::nullopt;

		int64_t totalOffset = lhs->first - rhs->first;
		llvm::Value* reg = lhs->second;

		if (rhs->second) return std::nullopt;

		return std::make_pair(totalOffset, reg);
	}
	else if (isa<LoadInst>(node->value) || isa<CastInst>(node->value))
	{
		// Stop recursion if we hit a load from stack register
		if (auto* li = dyn_cast<LoadInst>(node->value))
		{
			auto* ptr = li->getPointerOperand();
			if (isStackRelatedRegister(ptr))
			{
				return std::make_pair(0, ptr);
			}
		}

		if (node->ops.size() == 1)
		{
			return calculateLinearOffset(&node->ops[0]);
		}
	}
	else if (isa<PtrToIntInst>(node->value) || isa<IntToPtrInst>(node->value))
	{
		if (node->ops.size() == 1)
		{
			return calculateLinearOffset(&node->ops[0]);
		}
	}

	return std::nullopt;
}

const std::vector<StackBoundaryInfo>& BPABoundaryCollector::getBoundaryInfo() const
{
	return _boundaryInfos;
}

void BPABoundaryCollector::printBoundaryReport(llvm::raw_ostream& os) const
{
	os << "\n";
	os << "╔══════════════════════════════════════════════════════════════════╗\n";
	os << "║           BPA Stack Boundary Collection Report                   ║\n";
	os << "╚══════════════════════════════════════════════════════════════════╝\n";
	os << "\n";

	for (const auto& info : _boundaryInfos)
	{
		os << "Function: " << info.functionName << "\n";
		os << "  Address: 0x" << llvm::format_hex(info.functionAddress, 0) << "\n";
		os << "  Total stack accesses: " << info.totalAccesses << "\n";
		os << "  Successfully processed: " << info.stackAccesses.size() << "\n";
		os << "  Unprocessed: " << info.unprocessedAccesses << "\n";
		
		if (!info.dynamicRegions.empty())
		{
			os << "  Dynamic stack regions: " << info.dynamicRegions.size() << "\n";
			for (const auto& region : info.dynamicRegions)
			{
				os << "    Region " << region.id << ": base=" << region.baseOffsetFromTop 
				   << ", size=" << (region.size > 0 ? std::to_string(region.size) : "unknown")
				   << " (" << region.description << ")\n";
			}
		}
		
		if (!info.topRelativeOffsets.empty())
		{
			os << "  Top-relative boundaries (candidates): [";
			bool first = true;
			for (int64_t offset : info.topRelativeOffsets)
			{
				if (!first) os << ", ";
				os << offset;
				first = false;
			}
			os << "]\n";
		}

		if (!info.rspBasedOffsets.empty())
		{
			os << "  Static RSP-based offsets: [";
			bool first = true;
			for (int64_t offset : info.rspBasedOffsets)
			{
				if (!first) os << ", ";
				os << offset;
				first = false;
			}
			os << "] (" << info.rspAccesses << " accesses)\n";
		}

		if (!info.rbpBasedOffsets.empty())
		{
			os << "  RBP-based offsets: [";
			bool first = true;
			for (int64_t offset : info.rbpBasedOffsets)
			{
				if (!first) os << ", ";
				os << offset;
				first = false;
			}
			os << "] (" << info.rbpAccesses << " accesses)\n";
		}
		
		if (info.dynamicRegionAccesses > 0)
		{
			os << "  Dynamic region accesses: " << info.dynamicRegionAccesses << "\n";
		}

		os << "\n";
	}

	os << "Summary:\n";
	os << "  Total functions analyzed: " << _boundaryInfos.size() << "\n";
	
	size_t totalBoundaries = 0;
	size_t totalRspAccesses = 0;
	size_t totalRbpAccesses = 0;
	size_t totalDynamicAccesses = 0;
	size_t totalDynamicRegions = 0;
	for (const auto& info : _boundaryInfos)
	{
		totalBoundaries += info.topRelativeOffsets.size();
		totalRspAccesses += info.rspAccesses;
		totalRbpAccesses += info.rbpAccesses;
		totalDynamicAccesses += info.dynamicRegionAccesses;
		totalDynamicRegions += info.dynamicRegions.size();
	}
	
	os << "  Total boundary candidates: " << totalBoundaries << "\n";
	os << "  Total static RSP accesses: " << totalRspAccesses << "\n";
	os << "  Total RBP accesses: " << totalRbpAccesses << "\n";
	os << "  Total dynamic region accesses: " << totalDynamicAccesses << "\n";
	os << "  Total dynamic regions: " << totalDynamicRegions << "\n";
	os << "\n";
}

std::string BPABoundaryCollector::getBoundaryReportJson() const
{
	std::string json = "{\n";
	json += "  \"functions\": [\n";
	
	bool firstFunc = true;
	for (const auto& info : _boundaryInfos)
	{
		if (!firstFunc) json += ",\n";
		firstFunc = false;
		
		json += "    {\n";
		json += "      \"name\": \"" + info.functionName + "\",\n";
		json += "      \"address\": " + std::to_string(info.functionAddress) + ",\n";
		json += "      \"totalAccesses\": " + std::to_string(info.totalAccesses) + ",\n";
		json += "      \"boundaries\": [";
		
		bool first = true;
		for (int64_t offset : info.topRelativeOffsets)
		{
			if (!first) json += ", ";
			json += std::to_string(offset);
			first = false;
		}
		json += "],\n";
		
		json += "      \"rspOffsets\": [";
		first = true;
		for (int64_t offset : info.rspBasedOffsets)
		{
			if (!first) json += ", ";
			json += std::to_string(offset);
			first = false;
		}
		json += "],\n";
		
		json += "      \"rbpOffsets\": [";
		first = true;
		for (int64_t offset : info.rbpBasedOffsets)
		{
			if (!first) json += ", ";
			json += std::to_string(offset);
			first = false;
		}
		json += "]\n";
		
		json += "    }";
	}
	
	json += "\n  ]\n}";
	return json;
}

} // namespace bin2llvmir
} // namespace retdec
