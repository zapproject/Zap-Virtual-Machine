// SPDX-License-Identifier: GNU

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

// Local dependencies
from zap.library import Zeus
from zap.model import model
from zap.stack import Stack
from zap.memory import Memory
from zap.accounts.library import Accounts
// Constructor
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt,
    native_token_address_: felt,
    contract_account_class_hash_,
    externally_owned_account_class_hash,
    account_proxy_class_hash,
) {
    return Zeus.constructor(
        owner,
        native_token_address_,
        contract_account_class_hash_,
        externally_owned_account_class_hash,
        account_proxy_class_hash,
    );
}

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
@view
func execute{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(value: felt, bytecode_len: felt, bytecode: felt*, calldata_len: felt, calldata: felt*) -> (
    stack_accesses_len: felt,
    stack_accesses: felt*,
    stack_len: felt,
    memory_accesses_len: felt,
    memory_accesses: felt*,
    memory_bytes_len: felt,
    gas_used: felt,
) {
    alloc_locals;
    local call_context: model.CallContext* = new model.CallContext(
        bytecode=bytecode,
        bytecode_len=bytecode_len,
        calldata=calldata,
        calldata_len=calldata_len,
        value=value,
    );
    let summary = Zeus.execute(call_context);
    let memory_accesses_len = summary.memory.squashed_end - summary.memory.squashed_start;
    let stack_accesses_len = summary.stack.squashed_end - summary.stack.squashed_start;

    return (
        stack_accesses_len=stack_accesses_len,
        stack_accesses=summary.stack.squashed_start,
        stack_len=summary.stack.len_16bytes,
        memory_accesses_len=memory_accesses_len,
        memory_accesses=summary.memory.squashed_start,
        memory_bytes_len=summary.memory.bytes_len,
        gas_used=summary.gas_used,
    );
}

// @notice Execute bytecode of a given contract account.
// @dev Read the bytecode content of an contract account and then executes it.
// @param address The address of the contract whose bytecode will be executed.
// @param value The deposited value by the instruction/transaction responsible for this execution.
// @param gas_limit Max gas the transaction can use.
// @param calldata_len The calldata length.
// @param calldata The calldata which contains the entry point and method parameters.
// @return stack_accesses_len The size of the accesses array of the stack delta.
// @return stack_accesses The dict accesses in the stack delta.
// @return stack_len The length of the stack.
// @return memory_accesses_len The size of the accesses array of the memory delta.
// @return memory_accesses The dict accesses in the memory delta.
// @return memory_bytes_len The memory length.
// @return evm_contract_address The EVM-format address of the called contract's address, i.e. the input variable "address".
// @return starknet_contract_address The Starknet-format address of the called contract's address.
// @return return_data_len The length of the return data.
// @return return_data The return data of the EVM.
// @return gas_used The gas used for the tx.
@external
func execute_at_address{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(address: felt, value: felt, gas_limit: felt, calldata_len: felt, calldata: felt*) -> (
    stack_accesses_len: felt,
    stack_accesses: felt*,
    stack_len: felt,
    memory_accesses_len: felt,
    memory_accesses: felt*,
    memory_bytes_len: felt,
    evm_contract_address: felt,
    starknet_contract_address: felt,
    return_data_len: felt,
    return_data: felt*,
    gas_used: felt,
) {
    alloc_locals;
    let summary = Zeus.execute_at_address(
        address=address,
        calldata_len=calldata_len,
        calldata=calldata,
        value=value,
        gas_limit=gas_limit,
    );
    let memory_accesses_len = summary.memory.squashed_end - summary.memory.squashed_start;
    let stack_accesses_len = summary.stack.squashed_end - summary.stack.squashed_start;

    return (
        stack_accesses_len=stack_accesses_len,
        stack_accesses=summary.stack.squashed_start,
        stack_len=summary.stack.len_16bytes,
        memory_accesses_len=memory_accesses_len,
        memory_accesses=summary.memory.squashed_start,
        memory_bytes_len=summary.memory.bytes_len,
        evm_contract_address=summary.evm_contract_address,
        starknet_contract_address=summary.starknet_contract_address,
        return_data_len=summary.return_data_len,
        return_data=summary.return_data,
        gas_used=summary.gas_used,
    );
}

// @notice Set the blockhash registry used by Zeus.
// @dev Set the blockhash registry which will be used to get the blockhashes.
// @param blockhash_registry_address_ The address of the new blockhash registry contract.
@external
func set_blockhash_registry{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    blockhash_registry_address_: felt
) {
    return Zeus.set_blockhash_registry(blockhash_registry_address_);
}

// @notice Get the blockhash registry used by Zeus.
// @return address The address of the current blockhash registry contract.
@view
func get_blockhash_registry{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    return Zeus.get_blockhash_registry();
}

// @notice Set the native token used by Zeus
// @dev Set the native token which will emulate the role of ETH on Ethereum
// @param native_token_address_ The address of the native token
@external
func set_native_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    native_token_address_: felt
) {
    return Zeus.set_native_token(native_token_address_);
}

// @notice Get the native token address
// @dev Return the address used to emulate the role of ETH on Ethereum
// @return native_token_address The address of the native token
@view
func get_native_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    native_token_address: felt
) {
    return Zeus.get_native_token();
}

// @notice Deploy a new contract account and execute constructor.
// @param bytes_len the constructor + contract bytecode length.
// @param bytes the constructor + contract bytecode.
// @return evm_contract_address The evm address that is mapped to the newly deployed starknet contract address.
// @return starknet_contract_address The newly deployed starknet contract address.
@external
func deploy_contract_account{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(bytecode_len: felt, bytecode: felt*) -> (
    evm_contract_address: felt, starknet_contract_address: felt
) {
    return Zeus.deploy_contract_account(bytecode_len, bytecode);
}

// @notice Deploy a new externally owned account.
// @param evm_address The evm address that is mapped to the newly deployed starknet contract address.
// @return starknet_contract_address The newly deployed starknet contract address.
@external
func deploy_externally_owned_account{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(evm_address: felt) -> (starknet_contract_address: felt) {
    return Zeus.deploy_externally_owned_account(evm_address);
}

// @notice Compute the starknet address of a contract given its EVM address
// @param evm_address The EVM address of the contract
// @return contract_address The starknet address of the contract
@view
func compute_starknet_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    evm_address: felt
) -> (contract_address: felt) {
    return Accounts.compute_starknet_address(evm_address);
}
