// GEN-01 · `some` vs `any`, hands-on · ⏱ 5 min — reference solution
// Task: TASKS-2-generics-sequences.md

// `some` = some specific type, and the compiler knows which.
// `any` = any type, erased.

// MARK: - Step 1: `some`, `some`

// func areEqual(_ lhs: some Equatable, _ rhs: some Equatable) -> Bool {
//     lhs == rhs
// }
//
// error: conflicting arguments to generic parameter 'Self'
// ('some Equatable' (generic parameter of global function 'areEqual(_:_:)') vs.
//  'some Equatable' (generic parameter of global function 'areEqual(_:_:)'))
//
// Each `some` in a parameter is its own generic parameter, so `lhs` and `rhs` can be two different types.
// That signature is `func areEqual<A: Equatable, B: Equatable>(_ lhs: A, _ rhs: B)`, and `==` needs one type.

// MARK: - Step 2: One generic parameter

/// Returns a Boolean value that indicates whether two values of the same type are equal.
func areEqual<Value: Equatable>(_ lhs: Value, _ rhs: Value) -> Bool {
    lhs == rhs
}

// MARK: - Step 3: `any`, `any`

// func areEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
//     lhs == rhs
// }
//
// error: binary operator '==' cannot be applied to two 'any Equatable' operands
//
// `==` requires `Self` on both sides. Two boxes can hold an `Int` and a `String`, so the compiler can't prove that
// the operands have the same type.

/// Returns a Boolean value that indicates whether two type-erased values are equal.
///
/// Values of different types are never equal.
func areEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
    // Passing `lhs` to a generic parameter opens the box, so inside the function its type is known again.
    func isEqual<Value: Equatable>(to value: Value) -> Bool {
        rhs as? Value == value
    }
    return isEqual(to: lhs)
}

// MARK: - Usage

print(areEqual(1, 1))
print(areEqual("a", "b"))
// areEqual(1, "1") // error: conflicting arguments to generic parameter 'Value' ('Int' vs. 'String')

let values: [any Equatable] = [1, "1", 1]
print(areEqual(values[0], values[1]))
print(areEqual(values[0], values[2]))
