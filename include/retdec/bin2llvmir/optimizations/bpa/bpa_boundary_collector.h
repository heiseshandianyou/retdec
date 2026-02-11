/**
* @file include/retdec/bin2llvmir/optimizations/bpa/bpa_boundary_collector.h
* @brief BPA Step 1: Collect stack boundary candidates
* 
* This pass implements the first step of BPA (Bounded Path Analysis):
* collecting candidate values for stack variable boundaries.
* 
* Unlike BPAStackAnalysis which modifies IR, this pass only:
* 1. Analyzes all RSP/RBP based memory accesses
* 2. Computes normalized offsets relative to "top" (initial RSP)
* 3. Collects boundary candidates for each function
* 4. Outputs analysis results without modifying LLVM IR
* 
* Example output for a function:
*   Function: test_rbp_locals
*   Top-relative boundaries: [-8, -12, -16, -20, -24]
*   RSP-based offsets: [0, -8, -16]
*   RBP-based offsets: [-4, -8, -12]
* 
* @copyright (c) 2024 RetDec Lacie Edition
*/

#ifndef RETDEC_BIN2LLVMIR_OPTIMIZATIONS_BPA_BPA_BOUNDARY_COLLECTOR_H
#define RETDEC_BIN2LLVMIR_OPTIMIZATIONS_BPA_BPA_BOUNDARY_COLLECTOR_H

#include <map>
#include <set>
#include <vector>
#include <string>
#include <cstdint>

#include <llvm/IR/Module.h>
#include <llvm/Pass.h>

#include "retdec/bin2llvmir/analyses/symbolic_tree.h"
#include "retdec/bin2llvmir/providers/abi/abi.h"
#include "retdec/bin2llvmir/providers/config.h"

namespace retdec {
namespace bin2llvmir {

/**
 * Stack boundary information for a single function
 */
struct StackBoundaryInfo
{
	std::string functionName;
	uint64_t functionAddress;
	
	// All normalized offsets relative to "top" (initial RSP at entry)
	// These are the BPA "boundary candidates"
	std::set<int64_t> topRelativeOffsets;
	
	// Offsets grouped by access type
	std::set<int64_t> rspBasedOffsets;  // [rsp + X]
	std::set<int64_t> rbpBasedOffsets;  // [rbp + X]
	
	// Raw offsets from instructions (for debugging)
	std::map<llvm::Instruction*, int64_t> instructionOffsets;
	
	// Statistics
	size_t totalAccesses = 0;
	size_t rspAccesses = 0;
	size_t rbpAccesses = 0;
	size_t unprocessedAccesses = 0;
};

/**
 * BPA Boundary Collector Pass
 * 
 * Step 1 of BPA: Collect stack variable boundary candidates.
 * This is a read-only analysis pass that does not modify IR.
 */
class BPABoundaryCollector : public llvm::ModulePass
{
	public:
		static char ID;
		BPABoundaryCollector();
		virtual bool runOnModule(llvm::Module& m) override;
		bool runOnModuleCustom(
				llvm::Module& m,
				Config* c,
				Abi* abi);

		// Get collected boundary information
		const std::vector<StackBoundaryInfo>& getBoundaryInfo() const;
		
		// Print boundary report
		void printBoundaryReport(llvm::raw_ostream& os) const;
		
		// Output JSON format for further processing
		std::string getBoundaryReportJson() const;

	private:
		bool run();
		
		// Analyze a single function
		StackBoundaryInfo analyzeFunction(llvm::Function& f);
		
		// Check if value is a stack-related register
		bool isStackRelatedRegister(llvm::Value* val);
		bool isRBPRegister(llvm::Value* val);
		
		// Compute normalized offset relative to "top"
		std::optional<int64_t> getNormalizedOffset(
				SymbolicTree& root,
				int64_t rbpToTopOffset);
		
		// Helper for linear offset calculation
		std::optional<std::pair<int64_t, llvm::Value*>> calculateLinearOffset(
				SymbolicTree* node);

	private:
		llvm::Module* _module = nullptr;
		Config* _config = nullptr;
		Abi* _abi = nullptr;
		
		std::vector<StackBoundaryInfo> _boundaryInfos;
};

} // namespace bin2llvmir
} // namespace retdec

#endif
