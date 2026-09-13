// TYP-06 · Typed `UserDefaults` · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `@propertyWrapper struct Stored<Value: Codable>` with `init(wrappedValue:key:store:)`.
// 2. `get` decodes from `UserDefaults`, `set` encodes; a missing value yields the default.
// 3. Create `enum AppSettings` with three stored settings, one of which is a custom `Codable` struct.
//
// Done when
// - [ ] All keys are gathered in one place instead of scattered as strings across the code
// - [ ] Working with a `Codable` struct (not just `Bool`/`String`) works
// - [ ] `store` is injected → the test uses `UserDefaults(suiteName:)`, not `.standard`
//
// Pitfall
// `UserDefaults` stores `Bool` natively. Wrapping a `Bool` in JSON is unnecessary overhead; consider a specialization.
