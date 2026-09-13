// CNC-06 · `AsyncStream` over a callback · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Take a callback-based API (e.g. `NotificationCenter` or your own `LocationManagerDelegate`).
// 2. Wrap it in an `AsyncStream` via `AsyncStream { continuation in ... }`.
// 3. Implement `continuation.onTermination` to unsubscribe.
//
// Done when
// - [ ] `for await event in stream` receives events
// - [ ] Exiting the loop (`break`) triggers `onTermination` — proven by a log
// - [ ] No leak: the observer unsubscribes and the object is deinitialized
// - [ ] `BufferingPolicy` (`.unbounded` or `.bufferingNewest(1)`) is chosen deliberately, with a justification
//
// Pitfall
// The default `.unbounded` means that if the consumer is slower than the producer, memory grows without limit. Frequent
// events (gestures, location) need `.bufferingNewest(1)`.
