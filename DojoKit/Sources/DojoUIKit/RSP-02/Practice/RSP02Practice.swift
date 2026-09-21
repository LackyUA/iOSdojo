// RSP-02 · Find the first responder · ⏱ 5 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Find the current first responder without recursing over `subviews`.
// 2. Use the nil-target trick: `UIApplication.shared.sendAction(_:to:nil,from:nil,for:)` with a handler that captures
//    `self`.
// 3. Explain in a comment why `to: nil` finds it.
//
// Steps
// 1. `@MainActor private static weak var found: UIResponder?` on a `UIResponder` extension, plus `@objc private func
//    captureFirstResponder(_ sender: Any?) { UIResponder.found = self }`.
// 2. `static var current: UIResponder?` clears `found`, calls `sendAction(#selector(captureFirstResponder), to: nil,
//    from: nil, for: nil)` and returns `found`.
// 3. Write the naive alternative — a recursive `subviews` walk checking `isFirstResponder` — and note that it misses
//    responders that are not views, such as a view controller that became first responder.
// 4. Make a `UITextField` first responder in a test host, call both versions and compare.
// 5. In a comment, connect the trick to `target(forAction:withSender:)`: a `nil` target means "start at the first
//    responder and walk up".
//
// Done when
// - [ ] The helper returns the text field that is currently first responder
// - [ ] The static holder is cleared before every lookup, so a stale result is impossible
// - [ ] The reference is `weak`
// - [ ] A case is documented where the recursive-subview version gives a different answer
//
// Pitfall
// The static holder is global mutable state; under strict concurrency it has to be main-actor isolated. And it must be
// `weak` — a strongly held first responder is a leaked view controller that nobody will attribute to this helper.
