// STA-03 · Pure `reduce` · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take `STA-02` and extract the logic into `func reduce(_ state: FeedState, _ action: FeedAction) -> FeedState`.
// 2. The function must be `static`, side-effect free and not `async`.
// 3. Describe side effects separately: `func effects(for action: FeedAction, state: FeedState) -> [Effect]`.
//
// Done when
// - [ ] The test calls `reduce` directly, without a ViewModel and without `await`
// - [ ] The same input always gives the same output — no `Date()`, `UUID()`, `random`
// - [ ] The network call isn't made in `reduce`; it's described as an `Effect`
// - [ ] A test with a sequence of 6 actions checks the final state
//
// Pitfall
// If a `Task { ... }` sneaks into `reduce`, it's no longer a pure function and the tests become async again. An effect
// must be **data**, not execution.
