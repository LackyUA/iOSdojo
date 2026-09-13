// GEN-01 · `some` vs `any`, hands-on · ⏱ 5 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Write `func areEqual(_ a: some Equatable, _ b: some Equatable) -> Bool` and see that it doesn't compile.
// 2. Fix it to `func areEqual<T: Equatable>(_ a: T, _ b: T) -> Bool`.
// 3. Write a version with `any Equatable` and try to compare the two values inside.
//
// Done when
// - [ ] You can explain in one sentence why `some, some` means two different types
// - [ ] The `any` version fails to compile on `a == b`, and you know why
// - [ ] Written in a comment: `some` = "some specific type, and the compiler knows which", `any` = "any type, erased"
//
// Pitfall
// `some` in parameter position is syntactic sugar for a generic. Two `some` in a signature = two independent type
// parameters.
