// STA-05 · Repository with `AsyncStream` · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `actor ItemRepository` with `all()`, `add(_:)`, `remove(_:)` and `var changes: AsyncStream<[Item]>`.
// 2. Support multiple subscribers (each gets its own stream).
// 3. Two "screens" subscribe, one adds an item — both see the change.
//
// Done when
// - [ ] Both subscribers received an update after a single `add`
// - [ ] Unsubscribing one doesn't break the other
// - [ ] A new subscriber gets the current state immediately, without waiting for the next change
// - [ ] `deinit`/`onTermination` removes the subscriber from the list
//
// Pitfall
// By default, `AsyncStream` is one consumer per stream. For broadcasting, keep an array of `continuation`s and send to
// each one manually.
