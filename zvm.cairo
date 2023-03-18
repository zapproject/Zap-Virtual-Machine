use zap::context::CallContext;
use zap::context::ExecutionContext;
use zap::context::ExecutionSummary;
use zap::context::ExecutionContextTrait;
use zap::instructions::EVMInstructionsTrait;

/// Execute EVM bytecode.
fn execute(call_context: CallContext) {
    // Create new execution context.
    let mut ctx = ExecutionContextTrait::new(call_context);
    // Compute the intrinsic gas cost for the current transaction and increase the gas used.
    ctx.process_intrinsic_gas_cost();
    // Print the execution context.
    ctx.print_debug();
    let mut evm_instructions = EVMInstructionsTrait::new();
    // Execute the transaction.
    evm_instructions.run(ref ctx)
}
