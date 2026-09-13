// TYP-01 · `NonEmptyString` · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct NonEmptyString { let rawValue: String }` with `init?(_ value: String)`.
// 2. The init trims whitespace and returns `nil` if the result is empty.
// 3. Add `Equatable`, `Hashable`, and `CustomStringConvertible`.
//
// Done when
// - [ ] `NonEmptyString("   ")` → `nil`
// - [ ] `rawValue` is never empty — this can't be proven by a test, only by the type's construction
// - [ ] The type is used in some model's field instead of `String`
//
// Pitfall
// `isEmpty` on a string with emoji or Unicode whitespace — check `"\u{200B}"` (zero-width space).
