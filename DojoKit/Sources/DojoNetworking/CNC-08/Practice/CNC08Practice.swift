// CNC-08 · `TaskGroup` with partial success · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Three independent requests (profile, settings, notifications) via `withThrowingTaskGroup`.
// 2. Variant A: any error — the whole operation fails.
// 3. Variant B: the result is `(profile: Profile, settings: Settings?, notifications: [Note]?)`, where only the profile
//    is critical.
//
// Done when
// - [ ] Variant A: an error in the second request cancels the third (proven by a log)
// - [ ] Variant B: a notifications failure doesn't break the screen
// - [ ] Both variants run concurrently, not sequentially — measured by timing
// - [ ] In a comment — the rule: what's critical and what degrades gracefully
//
// Pitfall
// Three sequential `await`s look almost the same as a group, but take three times as long. Measure the time — it's the
// only way to be sure the parallelism is real.
