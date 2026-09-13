// CNC-05 · Actor cache with TTL · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `actor TTLCache<Key: Hashable, Value>` with `[Key: (value: Value, expiresAt: Date)]` storage.
// 2. `func value(for key: Key) async -> Value?` — an expired entry returns `nil` and is removed.
// 3. Add `func value(for key: Key, orLoad load: @Sendable () async throws -> Value) async throws -> Value`.
//
// Done when
// - [ ] No `NSLock` and no `DispatchQueue`
// - [ ] An expired value is never returned — tested with the fake clock from `CNC-04`
// - [ ] 10 concurrent requests for the same key call `load` exactly once (this partly overlaps with `CNC-07`)
// - [ ] Compiles without `Sendable` warnings when `Value: Sendable`
//
// Pitfall
// An `await` inside an actor method creates a **suspension point**: the state may have changed after it. Re-check the
// storage after `await load()`.
