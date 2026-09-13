// TYP-05 · `Result<Value, Never>` and `Never` · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Write a function that returns `Result<Int, Never>` and extract the value without `try`/`catch`.
// 2. Try writing `case .failure(let error)` and see what the compiler says about unreachability.
// 3. Write your own function with a `Never` return type and call it at the end of a `switch` branch.
//
// Done when
// - [ ] `get()` on `Result<Int, Never>` is called without `try`
// - [ ] The `.failure` branch is either removed or flagged by the compiler as unreachable
// - [ ] The `Never`-returning function is used as an expression (e.g. in a ternary or `??`)
//
// Pitfall
// `Never` conforms to `Error` only since Swift 5.0+, and that's exactly why `Result<_, Never>` is possible at all —
// make sure you understand why.
