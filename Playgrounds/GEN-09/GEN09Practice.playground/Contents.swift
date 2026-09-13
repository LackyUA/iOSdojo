// GEN-09 · `where Self: Equatable` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `protocol Identifiable2 { var id: String { get } }` (your own, so it doesn't clash with the stdlib).
// 2. Add `extension Identifiable2 where Self: Equatable { func isSame(as other: Self) -> Bool }`.
// 3. Make two types, one `Equatable` and one not, and check that only the first has the method.
//
// Done when
// - [ ] The method is unavailable on the type without `Equatable` — a compile error
// - [ ] No second `EquatableIdentifiable` protocol was created
// - [ ] Autocomplete shows a different set of methods on the two types
//
// Pitfall
// `where Self: X` in an extension is not the same as `protocol A: X`. The latter forces **every** conformer to conform
// to `X`.
