# The Zap Virtual Machine ZK-EVM
Zeus is the Working Title for the Zap Virtual Machine implemented in Cairo. 
It is deployed on StarkNet with it's own respective EVM Compatiable RPC, StarkNet is a layer 2 scaling solution for Ethereum,
where you can run any EVM bytecode program. Hence, Zeus can run Ethereum smart contracts and oracles on StarkNet.
It is a work in progress, and it is not ready for production.



// @notice Execute EVM bytecode.
// @dev Execute a provided array of evm opcodes/bytes.
// @param value The deposited value by the instruction/transaction responsible for this execution.
// @param bytecode_len The bytecode length.
// @param bytecode The bytecode to be executed.
// @param calldata_len The calldata length.
// @param calldata The calldata which can be referenced by the bytecode.
// @return stack_accesses_len The size of the accesses array of the stack delta.
// @return stack_accesses The dict accesses in the stack delta.
// @return stack_len The length of the stack.
// @return memory_accesses_len The size of the accesses arrayof the memory delta.
// @return memory_accesses The dict accesses in the memory delta.
// @return memory_bytes_len The memory length.
// @return memory The EVM memory content.
// @return gas_used The total amount of gas used to execute the given bytecode.
