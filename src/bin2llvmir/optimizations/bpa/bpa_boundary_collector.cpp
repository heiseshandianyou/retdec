/**
* @file src/bin2llvmir/optimizations/bpa/bpa_boundary_collector.cpp
* @brief BPA Step 1: Collect stack boundary candidates
* 
* This pass collects candidate values for stack variable boundaries
* without modifying LLVM IR. It is the first step of BPA.
*/

#include <capstone/x86.h>

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

	// Assume standard frame setup: rbp = top - 8
	int64_t rbpToTopOffset = -8;

	LOG << "Analyzing function: " << info.functionName << std::endl;

	ReachingDefinitionsAnalysis RDA;
	RDA.runOnModule(*_module, _abi);

	// Collect all memory access instructions
	for (auto& bb : f)
	{
		for (auto& inst : bb)
		{
			// Look for load/store that might be stack accesses
			Value* pointerOperand = nullptr;
			
			if (auto* load = dyn_cast<LoadInst>(&inst))
			{
				pointerOperand = load->getPointerOperand();
			}
			else if (auto* store = dyn_cast<StoreInst>(&inst))
			{
				pointerOperand = store->getPointerOperand();
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
			for (SymbolicTree* n : root.getPostOrder())
			{
				if (isStackRelatedRegister(n->value))
				{
					hasStackReg = true;
					break;
				}
			}

			if (!hasStackReg)
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

			int64_t offset = normalizedOffset.value();
			info.topRelativeOffsets.insert(offset);
			info.instructionOffsets[&inst] = offset;

			// Classify by register type
			for (SymbolicTree* n : root.getPostOrder())
			{
				if (isRBPRegister(n->value))
				{
					info.rbpBasedOffsets.insert(offset);
					info.rbpAccesses++;
					break;
				}
				else if (_abi->isStackPointerRegister(n->value) ||
				         (isa<GlobalVariable>(n->value) && 
				          (n->value->getName() == "rsp" || n->value->getName() == "esp")))
				{
					info.rspBasedOffsets.insert(offset);
					info.rspAccesses++;
					break;
				}
			}
		}
	}

	LOG << "  Collected " << info.topRelativeOffsets.size() << " boundary candidates" << std::endl;
	
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
		os << "  Successfully processed: " << info.topRelativeOffsets.size() << "\n";
		os << "  Unprocessed: " << info.unprocessedAccesses << "\n";
		
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
			os << "  RSP-based offsets: [";
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

		os << "\n";
	}

	os << "Summary:\n";
	os << "  Total functions analyzed: " << _boundaryInfos.size() << "\n";
	
	size_t totalBoundaries = 0;
	size_t totalRspAccesses = 0;
	size_t totalRbpAccesses = 0;
	for (const auto& info : _boundaryInfos)
	{
		totalBoundaries += info.topRelativeOffsets.size();
		totalRspAccesses += info.rspAccesses;
		totalRbpAccesses += info.rbpAccesses;
	}
	
	os << "  Total boundary candidates: " << totalBoundaries << "\n";
	os << "  Total RSP-based accesses: " << totalRspAccesses << "\n";
	os << "  Total RBP-based accesses: " << totalRbpAccesses << "\n";
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
