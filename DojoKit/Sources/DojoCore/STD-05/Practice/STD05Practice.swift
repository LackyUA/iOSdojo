// STD-05 · `RawRepresentable` for keys · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct FeatureKey: RawRepresentable, Hashable { let rawValue: String }`.
// 2. Add static constants: `static let newOnboarding = FeatureKey(rawValue: "new_onboarding")`.
// 3. Replace `func isEnabled(_ key: String)` with `func isEnabled(_ key: FeatureKey)`.
//
// Done when
// - [ ] `isEnabled("new_onboardng")` (with a typo) no longer compiles
// - [ ] Autocomplete shows all available keys after typing `.`
// - [ ] A key can be added from another module without changing the type (compare with an enum)
//
// Pitfall
// This is exactly the case where a `struct` beats an `enum`: an enum is closed to extension, while feature flags are
// added all the time.
