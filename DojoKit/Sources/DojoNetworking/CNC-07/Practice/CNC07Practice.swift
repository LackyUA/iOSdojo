// CNC-07 · Request deduplication · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `actor ImageLoader` with `[URL: Task<Data, Error>]` storage.
// 2. `func load(_ url: URL) async throws -> Data`: if a task already exists — `await` it, otherwise create one.
// 3. Test: 10 concurrent `load` calls for the same URL → exactly 1 network call.
//
// Done when
// - [ ] The mock client's call counter shows `1`, not `10`
// - [ ] All 10 callers received the same result
// - [ ] The task is removed from storage once it completes
// - [ ] A failed request doesn't leave a "poisoned" task in the cache forever
//
// Pitfall
// If you don't remove the task after it completes, the very first error gets cached forever — subsequent requests keep
// failing even though the network is back.
