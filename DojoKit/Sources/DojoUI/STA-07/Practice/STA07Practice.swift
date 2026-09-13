// STA-07 · Remote + cache behind one protocol · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `protocol ItemSource { func items() async throws -> [Item] }`.
// 2. `RemoteItemSource`, `CachedItemSource`, and `CompositeItemSource`, which tries the cache, then the network.
// 3. Three composition strategies: `cacheFirst`, `remoteFirst`, `cacheThenRemote` (returns twice via a stream).
//
// Done when
// - [ ] The ViewModel takes `any ItemSource` and doesn't know the cache exists
// - [ ] Switching strategy is one line at the composition root
// - [ ] The ViewModel has no `if hasCache`
// - [ ] A `cacheFirst` test with an empty cache goes to the network
//
// Pitfall
// `cacheThenRemote` doesn't fit `() async throws -> [Item]` — it needs an `AsyncStream` or a separate protocol. That's
// the signal the abstraction is leaking; resolve it explicitly, not with a hack.
