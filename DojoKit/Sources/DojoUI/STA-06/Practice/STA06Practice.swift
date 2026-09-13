// STA-06 · Feature flags via Strategy · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `protocol FeatureFlagSource { func value(for key: FeatureKey) -> Bool? }` (from `STD-05`).
// 2. Three implementations: `RemoteSource`, `LocalDefaultsSource`, `DebugOverrideSource`.
// 3. `struct FeatureFlags` with an ordered array of sources — the first one to return non-`nil` wins.
//
// Done when
// - [ ] Debug override beats remote — proven by a test
// - [ ] No `if isDebug` inside `FeatureFlags`
// - [ ] Adding a fourth source doesn't change any existing type
// - [ ] If every source returns `nil`, the default defined alongside the key is used
//
// Pitfall
// Source order is configuration, not a constant in code. Pass it through init, otherwise a test can't verify a
// different order.
