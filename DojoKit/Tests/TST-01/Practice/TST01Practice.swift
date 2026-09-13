// TST-01 · Parameterized tests · ⏱ 15 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take the validator from `GEN-04`/`SOL-07`.
// 2. `@Test(arguments: [...])` with an array of `(input, expected)` tuples — at least 8 cases.
// 3. A second test with `arguments:` of two collections (Cartesian product).
//
// Done when
// - [ ] One test instead of 8 copies
// - [ ] Each case is visible separately in the report (not "1 test passed")
// - [ ] One failing case doesn't hide the rest
// - [ ] The case name in the report is readable — not `arg0`
//
// Pitfall
// The Cartesian product of two 10-element arrays is 100 tests. If each one is heavy, the run time grows unnoticed; use
// `zip(...)` for pairwise cases when you don't need the product.
