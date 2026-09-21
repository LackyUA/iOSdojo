// RSP-05 · An edit menu through `canPerformAction` · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Attach a `UIEditMenuInteraction` to a custom view and present the menu on a long press.
// 2. Filter the standard items with `canPerformAction(_:withSender:)`: allow `copy:`, deny `paste:`.
// 3. Add one custom item and handle it.
//
// Steps
// 1. `addInteraction(UIEditMenuInteraction(delegate: self))` — iOS 16+. Note in a comment what it replaced
//    (`UIMenuController`) and why the old API's global singleton was a problem.
// 2. The view has to be first responder for the menu to route its actions, so `canBecomeFirstResponder` comes back —
//    call `becomeFirstResponder()` before presenting.
// 3. Inject the custom `UIAction` from `editMenuInteraction(_:menuFor:suggestedActions:)`.
// 4. `override func canPerformAction(_:withSender:)` returning `true` only for the selectors you actually implement and
//    `super` otherwise. Watch the standard menu shrink.
// 5. Implement `override func copy(_ sender: Any?)` writing to `UIPasteboard.general`, and assert the pasteboard
//    contents in a test.
//
// Done when
// - [ ] The menu appears on the custom view with Copy and without Paste
// - [ ] `copy(_:)` actually puts the value on the pasteboard
// - [ ] The custom item runs its handler
// - [ ] A comment records why the view had to become first responder
//
// Pitfall
// Returning `true` from `canPerformAction` for a selector nobody implements shows the item and then sends the action to
// a responder that has no such method — an unrecognized-selector crash at the moment the user taps it. The `true`
// branches and the implemented methods must stay in sync.
