// SRV-09 · Generic `Store<T>` · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `protocol Persistence { func write(_ data: Data, key: String) throws; func read(key: String) throws -> Data? }`.
// 2. Two implementations: `FilePersistence`, `InMemoryPersistence` (Keychain is a bonus).
// 3. `struct Store<T: Codable>` on top of `Persistence` with `save(_:)`, `load()`, `delete()`.
//
// Done when
// - [ ] `Store<User>` and `Store<[Order]>` work without changes to the type
// - [ ] Swapping `FilePersistence` for `InMemoryPersistence` is one line in a test
// - [ ] `load()` on a missing key returns `nil`, doesn't throw
// - [ ] A corrupted file produces a clear error, not a crash
//
// Pitfall
// The coder (`JSONEncoder`) should also be injected, or at least configured — otherwise a `Date` gets saved in one
// format and read back in another after the defaults change.
