// Utilities for kakarot standard library.
use array::ArrayTrait;
use option::OptionTrait;

// Panic with a custom message.
fn panic_with(err: felt252) {
let mut data = ArrayTrait::new();
data.append(err);
panic(data);
}

// Convert a felt252 to a NonZero type.
fn to_non_zero(felt252: felt252) -> Option::<NonZero::<felt252>> {
match felt252_is_zero(felt252) {
IsZeroResult::Zero(()) => Option::<NonZero::<felt252>>::None(()),
IsZeroResult::NonZero(val) => Option::<NonZero::<felt252>>::Some(val),
}
}

// Force conversion from felt252 to u128.
fn unsafe_felt252_to_u128(a: felt252) -> u128 {
integer::u128_try_from_felt252(a).unwrap()
}

// Perform euclidean division on felt252 types.
fn unsafe_euclidean_div_no_remainder(a: felt252, b: felt252) -> felt252 {
integer::u128_to_felt252(unsafe_felt252_to_u128(a) / unsafe_felt252_to_u128(b))
}

fn unsafe_euclidean_div(a: felt252, b: felt252) -> (felt252, felt252) {
let a_u128 = unsafe_felt252_to_u128(a);
let b_u128 = unsafe_felt252_to_u128(b);
(integer::u128_to_felt252(a_u128 / b_u128), integer::u128_to_felt252(a_u128 % b_u128))
}

fn max(a: usize, b: usize) -> usize {
if a > b { a } else { b }
}

// Raise a number to a power.
fn pow(base: felt252, exp: felt252) -> felt252 {
if let Option::None(_) = gas::get_gas() {
panic_with('OOG');
}

    match exp {
        0 => 1,
        _ => base * pow(base, exp - 1),
    }
}

/// Panic with a custom code.
/// # Arguments
/// * `code` - The code to panic with. Must be a short string to fit in a felt252.
fn panic_with_code(code: felt252) {
    let mut data = ArrayTrait::new();
    data.append(code);
    panic(data);
}
