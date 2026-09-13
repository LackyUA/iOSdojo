// CNC-04 · Abstract `Clock` · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Write debounce or timeout logic that uses `Task.sleep`.
// 2. Replace it with an injected `any Clock<Duration>` (or your own `protocol Sleeping`).
// 3. In the test, substitute a fake clock that doesn't sleep, and verify the logic.
//
// Done when
// - [ ] A test for a 30-second timeout runs in milliseconds
// - [ ] 100 runs — 100 times green (no flakiness)
// - [ ] Production code uses `ContinuousClock` by default
//
// Pitfall
// `ContinuousClock` vs `SuspendingClock`: the former keeps ticking while the app is in the background, the latter
// doesn't. Network timeouts need `ContinuousClock`.
