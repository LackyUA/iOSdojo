// SRV-11 · Singleton → injection · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Take (or write) a `final class SettingsManager` with `static let shared` and 15 usage sites.
// 2. Extract `protocol SettingsProviding` and make `shared` its implementation.
// 3. Inject it into 3 sites via init, and leave the remaining 12 on `shared` — but marked `@available(*, deprecated)`.
//
// Done when
// - [ ] The three injected sites are tested without `shared`
// - [ ] The compiler emits a warning for each of the remaining 12 usages — a visible work list
// - [ ] `shared` isn't deleted: the code compiles and works
// - [ ] In a comment — a plan for the order in which to migrate the rest
//
// Pitfall
// Trying to remove a singleton in one commit means 200 changed files and a dead PR. A `deprecated` shim puts the
// compiler to work building your backlog.
