// CNC-03 · Real cancellation · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Write `func process(_ items: [Item]) async throws` with a loop and heavy work on each item.
// 2. Run it in a `Task`, call `cancel()` after 100 ms, and log that the loop kept going.
// 3. Add `try Task.checkCancellation()` to the loop and repeat.
//
// Done when
// - [ ] The first variant proves the problem: all items were processed after cancel
// - [ ] The second variant stops at the very first item after cancel
// - [ ] `CancellationError` propagates upward instead of being swallowed
// - [ ] Resources (an open file, a transaction) are released in `defer`
//
// Pitfall
// `Task.cancel()` just sets a flag. Cancellation is cooperative: if your code doesn't check for it, it won't happen.
