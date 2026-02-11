/**
* @file include/retdec/bin2llvmir/optimizations/bpa/bpa_stack.h
* @brief BPA-style Stack Analysis - Unified RSP/RBP handling
* @copyright (c) 2024 RetDec Lacie Edition
*/

#ifndef RETDEC_BIN2LLVMIR_OPTIMIZATIONS_BPA_BPA_STACK_H
#define RETDEC_BIN2LLVMIR_OPTIMIZATIONS_BPA_BPA_STACK_H

#include <optional>
#include <unordered_set>
#include <cstdint>

#include <llvm/IR/Module.h>
#include <llvm/Pass.h>

#include "retdec/bin2llvmir/analyses/symbolic_tree.h"
#include "retdec/bin2llvmir/providers/abi/abi.h"
#include "retdec/bin2llvmir/providers/config.h"
#include "retdec/bin2llvmir/providers/debugformat.h"

namespace retdec {
namespace bin2llvmir {

/**
 * BPA Stack Analysis Pass
 * 
 * Unlike original StackAnalysis which only handles RSP-based accesses,
 * this pass handles BOTH RSP and RBP based accesses by normalizing
 * them to offsets from "top" (initial RSP at function entry).
 * 
 * Variable naming: stack_top_XXX where XXX is the normalized offset
 * 
 * Examples:
 *   [rsp + 16] at entry -> stack_top_16 (RSP relative)
 *   [rbp - 8] with rbp=top-8 -> stack_top_-16 (RBP normalized)
 */
class BPAStackAnalysis : public llvm::ModulePass
{
	public:
		static char ID;
		BPAStackAnalysis();
		virtual bool runOnModule(llvm::Module& m) override;
		bool runOnModuleCustom(
				llvm::Module& m,
				Config* c,
				Abi* abi,
				DebugFormat* dbgf = nullptr);

	private:
		bool run();
		void handleInstruction(
				ReachingDefinitionsAnalysis& RDA,
				llvm::Instruction* inst,
				llvm::Value* val,
				llvm::Type* type,
				int64_t rbpToTopOffset);
		
		// Check if value is a stack-related register (RSP/ESP or RBP/EBP)
		bool isStackRelatedRegister(llvm::Value* val);
		bool isRBPRegister(llvm::Value* val);
		
		// Compute normalized offset relative to "top"
		std::optional<int64_t> getNormalizedOffset(
				SymbolicTree& root,
				int64_t rbpToTopOffset);

		// Helper to recursively calculate linear offset from a tree
		// Returns {total_offset, register_value} if successful
		std::optional<std::pair<int64_t, llvm::Value*>> calculateLinearOffset(
				SymbolicTree* node);
		
		const retdec::common::Object* getDebugStackVariable(
				llvm::Function* fnc,
				SymbolicTree& root,
				int64_t rbpToTopOffset);
		const retdec::common::Object* getConfigStackVariable(
				llvm::Function* fnc,
				SymbolicTree& root,
				int64_t rbpToTopOffset);

	private:
		llvm::Module* _module = nullptr;
		Config* _config = nullptr;
		Abi* _abi = nullptr;
		DebugFormat* _dbg = nullptr;
		std::unordered_set<llvm::Value*> _toRemove;
};

} // namespace bin2llvmir
} // namespace retdec

#endif
