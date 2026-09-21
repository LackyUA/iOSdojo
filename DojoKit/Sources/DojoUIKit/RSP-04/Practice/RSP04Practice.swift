// RSP-04 · A custom action up the chain · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Declare an action a deep subview can send without knowing who handles it — an `@objc` method signature such as
//    `didRequestRemove(_:)`.
// 2. Send it from a button inside a cell with `UIApplication.shared.sendAction(_:to:nil,from:self,for:)`.
// 3. Implement it on the view controller two levels up, and veto it from an intermediate view with
//    `canPerformAction(_:withSender:)`.
//
// Steps
// 1. Sender side: no delegate, no closure, no `target`. `sendAction(_:to:nil,from:sender,for:)` starts at `sender` and
//    walks `next`.
// 2. Receiver side: an `@objc` method on the view controller. The selector must match exactly, `sender` argument
//    included.
// 3. Add `override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool` on an intermediate view,
//    return `false` for this action, and watch the event travel past it to the next handler.
// 4. Use `target(forAction:withSender:)` in a test to assert who would handle the action, without sending it.
// 5. Write the trade-off down: against a delegate and against a closure — what you lose (the compile-time guarantee
//    that somebody handles it, and discoverability) and what you gain (no wiring through three layers).
//
// Done when
// - [ ] The button holds no reference to the view controller, direct or indirect
// - [ ] `target(forAction:withSender:)` is asserted in a test, so routing is verified without UI
// - [ ] Vetoing in `canPerformAction` demonstrably moves handling one step up
// - [ ] A comment states when you would still pick a delegate
//
// Pitfall
// The failure mode is a silent no-op: misspell the selector or forget `@objc` and `sendAction` simply returns `false`.
// Always check that `Bool`, and cover the routing with a `target(forAction:)` test.
