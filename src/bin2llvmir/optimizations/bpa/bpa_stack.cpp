/**
* @file src/bin2llvmir/optimizations/bpa/bpa_stack.cpp
* @brief BPA-style Stack Analysis - Unified RSP/RBP handling
* 
* Key differences from original StackAnalysis:
* 1. Handles BOTH RSP and RBP based accesses
* 2. Normalizes RBP offsets to top-based offsets
* 3. Names variables as stack_top_XXX for clarity
* 
* Example:
*   [rsp + 16] at function entry -> stack_top_16 (offset = 16)
*   [rbp - 8] with rbp = top - 8 -> stack_top_-16 (offset = -8 + (-8) = -16)
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

#include "retdec/bin2llvmir/analyses/reaching_definitions.h"
#include "retdec/bin2llvmir/optimizations/bpa/bpa_stack.h"
#include "retdec/bin2llvmir/providers/asm_instruction.h"
#include "retdec/bin2llvmir/utils/ir_modifier.h"
#define debug_enabled true
#include "retdec/bin2llvmir/utils/llvm.h"

using namespace llvm;

namespace retdec {
namespace bin2llvmir {

char BPAStackAnalysis::ID = 0;

static RegisterPass<BPAStackAnalysis> X(
		"retdec-bpa-stack",
		"BPA Stack optimization (unified RSP/RBP handling)",
		false,
		false
);

BPAStackAnalysis::BPAStackAnalysis() :
		ModulePass(ID)
{
}

bool BPAStackAnalysis::runOnModule(llvm::Module& m)
{
	_module = &m;
	_config = ConfigProvider::getConfig(_module);
	_abi = AbiProvider::getAbi(_module);
	_dbg = DebugFormatProvider::getDebugFormat(_module);
	return run();
}

bool BPAStackAnalysis::runOnModuleCustom(
		llvm::Module& m,
		Config* c,
		Abi* abi,
		DebugFormat* dbgf)
{
	_module = &m;
	_config = c;
	_abi = abi;
	_dbg = dbgf;
	return run();
}

bool BPAStackAnalysis::run()
{
	if (_config == nullptr)
	{
		return false;
	}

	ReachingDefinitionsAnalysis RDA;
	RDA.runOnModule(*_module, _abi);

	for (auto& f : *_module)
	{
		// Compute RBP offset for this function (typically -8 after push rbp; mov rbp, rsp)
		// For simplicity, we assume standard frame setup: rbp = top - 8
		// A full implementation would track this per instruction
		int64_t rbpToTopOffset = -8;  // rbp = top - 8
		
		for (inst_iterator I = inst_begin(f), E = inst_end(f); I != E; ++I)
		{
			Instruction& i = *I;

			// Log every instruction to see if we missed RBP accesses
            if (debug_enabled) LOG << "Visiting: " << llvmObjToString(&i) << std::endl;

			if (StoreInst *store = dyn_cast<StoreInst>(&i))
			{
				LOG << "Processing Store: " << llvmObjToString(store) << std::endl;
				
				if (AsmInstruction::isLlvmToAsmInstruction(store))
				{
					LOG << "  -> Skipped (LLVM to ASM)" << std::endl;
					continue;
				}

				handleInstruction(
						RDA,
						store,
						store->getValueOperand(),
						store->getValueOperand()->getType(),
						rbpToTopOffset);

				if (isa<GlobalVariable>(store->getPointerOperand()))
				{
					continue;
				}

				handleInstruction(
						RDA,
						store,
						store->getPointerOperand(),
						store->getValueOperand()->getType(),
						rbpToTopOffset);
			}
			else if (LoadInst* load = dyn_cast<LoadInst>(&i))
			{
				if (isa<GlobalVariable>(load->getPointerOperand()))
				{
					continue;
				}

				handleInstruction(
						RDA,
						load,
						load->getPointerOperand(),
						load->getType(),
						rbpToTopOffset);
			}
		}
	}

	IrModifier::eraseUnusedInstructionsRecursive(_toRemove);

	return false;
}

void BPAStackAnalysis::handleInstruction(
		ReachingDefinitionsAnalysis& RDA,
		llvm::Instruction* inst,
		llvm::Value* val,
		llvm::Type* type,
		int64_t rbpToTopOffset)
{
	// Special debug for [rbp-12] pattern
	std::string instStr = llvmObjToString(inst);
	if (instStr.find("store i32 10") != std::string::npos)
	{
		LOG << "=== DEBUG [rbp-12] ===" << std::endl;
		LOG << "Instruction: " << instStr << std::endl;
		LOG << "Val: " << llvmObjToString(val) << std::endl;
	}
	
	LOG << llvmObjToString(inst) << std::endl;

	// Use OnDemandRda to avoid val2val mapping issues
	auto root = SymbolicTree::OnDemandRda(val);
	LOG << root << std::endl;

	// Check for stack or base pointer in the expression
	bool hasStackReg = false;
	LOG << "Checking for stack registers in tree..." << std::endl;
	for (SymbolicTree* n : root.getPostOrder())
	{
		LOG << "  Checking node: " << llvmObjToString(n->value) << std::endl;
		if (isStackRelatedRegister(n->value))
		{
			LOG << "  -> Found stack register!" << std::endl;
			hasStackReg = true;
			break;
		}
	}
	
	if (!hasStackReg)
	{
		LOG << "===> no SP/BP" << std::endl;
		return;
	}

	// Get the normalized offset BEFORE simplifyNode() to preserve register info
	LOG << "Calling getNormalizedOffset..." << std::endl;
	auto normalizedOffset = getNormalizedOffset(root, rbpToTopOffset);
	
	auto* debugSv = getDebugStackVariable(inst->getFunction(), root, rbpToTopOffset);
	auto* configSv = getConfigStackVariable(inst->getFunction(), root, rbpToTopOffset);

	root.simplifyNode();
	LOG << root << std::endl;

	if (debugSv == nullptr)
	{
		debugSv = getDebugStackVariable(inst->getFunction(), root, rbpToTopOffset);
	}

	if (configSv == nullptr)
	{
		configSv = getConfigStackVariable(inst->getFunction(), root, rbpToTopOffset);
	}
	if (!normalizedOffset.has_value())
	{
		LOG << "===> could not compute normalized offset" << std::endl;
		return;
	}
	
	LOG << "===> SUCCESS: Normalized offset from top: " << normalizedOffset.value() << std::endl;

	// Note: val2val mapping disabled for now as it causes issues
	// with register tracking in subsequent instructions

	std::string name = "";
	Type* t = type;

	if (debugSv)
	{
		name = debugSv->getName();
		t = llvm_utils::stringToLlvmTypeDefault(_module, debugSv->type.getLlvmIr());
	}
	else if (configSv)
	{
		name = configSv->getName();
		t = llvm_utils::stringToLlvmTypeDefault(_module, configSv->type.getLlvmIr());
	}

	std::string realName;
	if (debugSv)
	{
		realName = debugSv->getName();
	}
	else if (configSv)
	{
		realName = configSv->getName();
	}

	// Use the normalized offset to create/get stack variable
	// Variable will be named "stack_top_XXX"
	IrModifier irModif(_module, _config);
	auto p = irModif.getStackVariable(
			inst->getFunction(),
			normalizedOffset.value(),
			t,
			name,
			realName,
			debugSv || configSv);

	AllocaInst* a = p.first;

	LOG << "===> " << llvmObjToString(a) << std::endl;
	LOG << "===> " << llvmObjToString(inst) << std::endl;
	LOG << std::endl;

	auto* s = dyn_cast<StoreInst>(inst);
	auto* l = dyn_cast<LoadInst>(inst);
	if (s && s->getPointerOperand() == val)
	{
		auto* conv = IrModifier::convertValueToType(
				s->getValueOperand(),
				a->getType()->getElementType(),
				inst);
		new StoreInst(conv, a, inst);
		_toRemove.insert(s);
	}
	else if (l && l->getPointerOperand() == val)
	{
		auto* nl = new LoadInst(a, "", l);
		auto* conv = IrModifier::convertValueToType(nl, l->getType(), l);
		l->replaceAllUsesWith(conv);
		_toRemove.insert(l);
	}
	else
	{
		auto* conv = IrModifier::convertValueToType(a, val->getType(), inst);
		_toRemove.insert(val);
		inst->replaceUsesOfWith(val, conv);
	}
}


bool BPAStackAnalysis::isStackRelatedRegister(llvm::Value* val)
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
	// This handles cases where SymbolicTree shows "load i64, i64* @rbp" 
	// but @rbp is not a separate node
	if (auto* li = dyn_cast<LoadInst>(val))
	{
		auto* ptr = li->getPointerOperand();
		if (isStackRelatedRegister(ptr))  // Recursive call for the pointer
		{
			return true;
		}
	}
	
	return false;
}

bool BPAStackAnalysis::isRBPRegister(llvm::Value* val)
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
	
	return false;
}

std::optional<int64_t> BPAStackAnalysis::getNormalizedOffset(
		SymbolicTree& root,
		int64_t rbpToTopOffset)
{
	LOG << "getNormalizedOffset called" << std::endl;
	LOG << "  Root value: " << llvmObjToString(root.value) << std::endl;
	LOG << "  Ops count: " << root.ops.size() << std::endl;
	
	auto res = calculateLinearOffset(&root);
	if (!res)
	{
		LOG << "  calculateLinearOffset returned nullopt" << std::endl;
		return std::nullopt;
	}
	
	LOG << "  Calculated offset: " << res->first << std::endl;
	LOG << "  Register: " << (res->second ? llvmObjToString(res->second) : "null") << std::endl;
	
	if (!res->second)
	{
		LOG << "  No register found" << std::endl;
		return std::nullopt;
	}

	int64_t offset = res->first;
	llvm::Value* reg = res->second;

	if (isStackRelatedRegister(reg))
	{
		if (isRBPRegister(reg))
		{
			LOG << "  -> RBP access, normalized offset: " << (rbpToTopOffset + offset) << std::endl;
			return rbpToTopOffset + offset;
		}
		else
		{
			LOG << "  -> RSP access, normalized offset: " << offset << std::endl;
			return offset;
		}
	}

	LOG << "  -> Not a stack register" << std::endl;
	return std::nullopt;
}

std::optional<std::pair<int64_t, llvm::Value*>> BPAStackAnalysis::calculateLinearOffset(
		SymbolicTree* node)
{
	LOG << "Calc: " << llvmObjToString(node->value) 
	    << " Ops: " << node->ops.size() << std::endl;
	
	// Check what kind of value this is
	if (isa<ConstantInt>(node->value)) LOG << "  -> ConstantInt" << std::endl;
	else if (_abi->isStackPointerRegister(node->value)) LOG << "  -> RSP register" << std::endl;
	else if (_abi->isRegister(node->value, X86_REG_RBP)) LOG << "  -> RBP register" << std::endl;
	else if (isa<AddOperator>(node->value)) LOG << "  -> AddOperator" << std::endl;
	else if (isa<SubOperator>(node->value)) LOG << "  -> SubOperator" << std::endl;
	else if (isa<LoadInst>(node->value)) LOG << "  -> LoadInst" << std::endl;
	else if (isa<CastInst>(node->value)) LOG << "  -> CastInst" << std::endl;
	else LOG << "  -> Other: " << node->value->getValueID() << std::endl;

	if (auto* ci = dyn_cast_or_null<ConstantInt>(node->value))
	{
		return std::make_pair(ci->getSExtValue(), nullptr);
	}
	else if (isStackRelatedRegister(node->value))
	{
		LOG << "  -> Found stack register terminal" << std::endl;
		return std::make_pair(0, node->value);
	}
	else if (isa<GlobalVariable>(node->value))
	{
		// Stop at any global variable to prevent expansion to alloca definitions
		LOG << "  -> Found global variable, stopping" << std::endl;
		return std::nullopt;
	}
	else if (isa<AddOperator>(node->value))
	{
		LOG << "  -> Processing AddOperator with " << node->ops.size() << " ops" << std::endl;
		int64_t totalOffset = 0;
		llvm::Value* reg = nullptr;

		for (size_t i = 0; i < node->ops.size(); ++i)
		{
			auto& op = node->ops[i];
			LOG << "  -> Processing op[" << i << "]" << std::endl;
			auto res = calculateLinearOffset(&op);
			if (!res) 
			{
				LOG << "  -> Op[" << i << "] returned nullopt" << std::endl;
				return std::nullopt;
			}
			
			LOG << "  -> Op[" << i << "] offset: " << res->first << ", reg: " << (res->second ? "yes" : "no") << std::endl;
			totalOffset += res->first;
			if (res->second)
			{
				if (reg && reg != res->second) 
				{
					LOG << "  -> Different registers found, aborting" << std::endl;
					return std::nullopt;
				}
				reg = res->second;
			}
		}
		LOG << "  -> AddOperator total offset: " << totalOffset << std::endl;
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

		if (rhs->second) return std::nullopt; // Subtracting a register is not supported

		return std::make_pair(totalOffset, reg);
	}
	else if (isa<LoadInst>(node->value) || isa<CastInst>(node->value))
	{
		// Critical Fix: Stop recursion if we hit a load from RBP/RSP
		// This prevents expanding registers into their defining operations
		if (auto* li = dyn_cast<LoadInst>(node->value))
		{
			auto* ptr = li->getPointerOperand();
			LOG << "  -> LoadInst ptr: " << llvmObjToString(ptr) << std::endl;
			if (isStackRelatedRegister(ptr))
			{
				LOG << "  -> Found stack register load terminal" << std::endl;
				return std::make_pair(0, ptr);
			}
			LOG << "  -> Not a stack register load" << std::endl;
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

const retdec::common::Object* BPAStackAnalysis::getDebugStackVariable(
		llvm::Function* fnc,
		SymbolicTree& root,
		int64_t rbpToTopOffset)
{
	auto normalizedOffset = getNormalizedOffset(root, rbpToTopOffset);
	if (!normalizedOffset.has_value())
	{
		return nullptr;
	}

	if (_dbg == nullptr)
	{
		return nullptr;
	}

	auto* debugFnc = _dbg->getFunction(_config->getFunctionAddress(fnc));
	if (debugFnc == nullptr)
	{
		return nullptr;
	}

	for (auto& var : debugFnc->locals)
	{
		if (!var.getStorage().isStack())
		{
			continue;
		}
		// Compare normalized offsets
		if (var.getStorage().getStackOffset() == normalizedOffset.value())
		{
			return &var;
		}
	}

	return nullptr;
}

const retdec::common::Object* BPAStackAnalysis::getConfigStackVariable(
		llvm::Function* fnc,
		SymbolicTree& root,
		int64_t rbpToTopOffset)
{
	auto normalizedOffset = getNormalizedOffset(root, rbpToTopOffset);
	if (!normalizedOffset.has_value())
	{
		return nullptr;
	}

	auto cfn = _config->getConfigFunction(fnc);
	if (cfn && _config->getLlvmStackVariable(fnc, normalizedOffset.value()) == nullptr)
	{
		for (auto& var: cfn->locals)
		{
			if (var.getStorage().getStackOffset() == normalizedOffset.value())
			{
				return &var;
			}
		}
	}

	return nullptr;
}

} // namespace bin2llvmir
} // namespace retdec
