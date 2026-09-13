// CNC-02 · Fixing `Sendable` · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Enable `-strict-concurrency=complete` (or `swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]`).
// 2. Take `final class Counter { var value = 0; func increment() }` and record all the warnings.
// 3. Fix it in three different ways: `actor`, `@MainActor`, and a struct with value semantics.
//
// Done when
// - [ ] Zero warnings in all three variants
// - [ ] For each variant, a comment on when it's appropriate
// - [ ] No `@unchecked Sendable` without locking and a justifying comment
//
// Pitfall
// `@unchecked Sendable` isn't a fix, it's a promise to the compiler. If you make it, you must have an
// `NSLock`/`DispatchQueue` inside and a comment explaining exactly what guarantees it.
