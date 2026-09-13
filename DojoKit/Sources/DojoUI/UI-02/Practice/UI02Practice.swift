// UI-02 · `EnvironmentKey` for a service · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `struct UserServiceKey: EnvironmentKey { static let defaultValue: any UserServicing = FailingUserService() }`.
// 2. An `extension EnvironmentValues` with a computed property.
// 3. A preview with a mock service that returns data immediately, and a second preview with a service that throws an
//    error.
//
// Done when
// - [ ] Both previews render without a network
// - [ ] `defaultValue` is a service that fails with a clear message, not an empty stub
// - [ ] Swapping the service for a subtree is a single `.environment(...)`
// - [ ] In a comment: when Environment is better than init injection, and when it's worse
//
// Pitfall
// A `defaultValue` that silently returns empty data hides a forgotten injection. Let it crash in debug: `fatalError` or
// `assertionFailure`.
