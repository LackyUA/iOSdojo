// SOL-07 · Composable validation · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take `GEN-08` (witness) or `GEN-04` (erasure).
// 2. Add operators: `&&` (both), `||` (at least one), `!`.
// 3. Build a password rule: `notEmpty && minLength(8) && (hasDigit || hasSymbol)`.
// 4. Add a new `notInBlocklist` rule without changing any existing type.
//
// Done when
// - [ ] The composition reads like a logical expression
// - [ ] The new rule is one new type/factory, 0 changed files
// - [ ] Errors from the `||` branch are aggregated meaningfully (not just the first one)
// - [ ] A test with 6 different passwords
//
// Pitfall
// `||` with errors is the hardest part. If both branches fail, which error do you show? Decide and document it: the
// first, the last, or both.
