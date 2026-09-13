// STD-04 · `OptionSet` instead of five `Bool`s · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Permissions: OptionSet { let rawValue: Int }` with five options.
// 2. Add composite constants: `static let editor: Permissions = [.read, .write]`.
// 3. Write checks using `contains`, `isSuperset(of:)`, `subtracting`.
//
// Done when
// - [ ] `Permissions` serializes as a single number
// - [ ] The "does the user have editor rights" check is one line without `&&`
// - [ ] Adding a sixth option doesn't require changing any existing check
//
// Pitfall
// `rawValue`s must be powers of two: `1`, `2`, `4`, `8`. `1 << 0`, `1 << 1` reads better and is harder to get wrong.
