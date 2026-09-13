// GEN-04 · `AnyValidator` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `protocol Validator { associatedtype Input; func validate(_ input: Input) throws }`.
// 2. Make three implementations (`NotEmpty`, `MinLength`, `EmailFormat`) and try to put them in a `[Validator]` —
//    record the compiler error.
// 3. Write a `struct AnyValidator<Input>: Validator` that wraps a closure, and build the array.
//
// Done when
// - [ ] The compiler error text is written down in a comment
// - [ ] `[AnyValidator<String>]` compiles and can be iterated in a loop
// - [ ] `init<V: Validator>(_ validator: V) where V.Input == Input` is added
//
// Pitfall
// Erasure keeps `Input` as a generic parameter, because otherwise `validate` can't be called type-safely. Only the
// concrete validator type is erased.
