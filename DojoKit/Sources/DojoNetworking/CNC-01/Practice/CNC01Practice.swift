// CNC-01 · `Result` → `async throws` · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Write a legacy API: `func load(completion: @escaping (Result<Data, Error>) -> Void)`.
// 2. Add an `async throws` version via `withCheckedThrowingContinuation`.
// 3. Verify the continuation is resumed exactly once on every branch.
//
// Done when
// - [ ] Success, error and cancellation — all three paths work
// - [ ] There's no path where completion isn't called (otherwise — an await that never returns)
// - [ ] There's no path where completion is called twice (otherwise — a crash)
// - [ ] `withCheckedThrowingContinuation` (not `unsafe`) — so the runtime catches mistakes
//
// Pitfall
// The most common bug is `guard let self else { return }` inside the completion without resuming the continuation. The
// task hangs forever without a single log line.
