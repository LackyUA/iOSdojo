// MOD-03 · Private init + factory · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Discount { let percent: Int }` with a `private init`.
// 2. Add `static func make(percent: Int) throws -> Discount` and `enum DiscountError: Error { case outOfRange(Int) }`.
// 3. Check the boundaries: `-1`, `0`, `50`, `100`, `101`.
//
// Done when
// - [ ] `Discount(percent: 200)` doesn't compile outside the type's file
// - [ ] All five checks give the expected result, and the error carries the invalid value
// - [ ] Once created, a `Discount` is guaranteed valid — no further `percent` checks are needed anywhere in the code
//
// Pitfall
// `private` in Swift is scoped to the file, not the type. For an honest check, call the init from another file.
