// COD-06 · Typed throws · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `func load() throws(LoadError) -> Data` with `enum LoadError: Error`.
// 2. Call it and make sure the `catch` is exhaustive without a `default`.
// 3. Write a second version with plain (untyped) `throws` and compare what changed at the call site.
//
// Done when
// - [ ] `do/catch` with typed throws compiles without a trailing `catch { }`
// - [ ] Trying to throw a different error from the typed function doesn't compile
// - [ ] In a comment — when typed throws hurts: a public API that may grow
//
// Pitfall
// `throws(any Error)` == plain `throws`, `throws(Never)` == doesn't throw. Typed throws in a library's public API makes
// adding a new error case a breaking change.
