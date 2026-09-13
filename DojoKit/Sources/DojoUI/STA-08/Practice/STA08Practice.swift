// STA-08 · Router as a protocol · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `protocol OrderListRouting { func showDetail(for id: OrderID); func showFilters() }`.
// 2. The ViewModel calls protocol methods without knowing about `NavigationPath` or `NavigationStack`.
// 3. Two implementations: a real `NavigationRouter` and a `SpyRouter` for tests.
//
// Done when
// - [ ] The ViewModel has no SwiftUI import
// - [ ] A test verifies that tapping a row called `showDetail(for:)` with the correct ID
// - [ ] Replacing `NavigationStack` with a modal doesn't touch the ViewModel
// - [ ] The protocol names domain actions, not UI ones (`showDetail`, not `pushViewController`)
//
// Pitfall
// If a `dismiss()` or `popToRoot()` method shows up in the protocol, the abstraction has leaked. The domain knows
// "order opened", not "screen pushed".
