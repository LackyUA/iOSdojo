// RSP-03 · A custom view that becomes first responder · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `final class PinCodeView: UIView` that takes keyboard input: `canBecomeFirstResponder` plus `UIKeyInput`.
// 2. An `inputAccessoryView` with a Done button that resigns.
// 3. Dismissal on a tap outside, without the "tap anywhere kills the keyboard" sledgehammer.
//
// Steps
// 1. `override var canBecomeFirstResponder: Bool { true }` — the default is `false`, and without it
//    `becomeFirstResponder()` just returns `false`.
// 2. Conform to `UIKeyInput`: `hasText`, `insertText(_:)`, `deleteBackward()`. Keep the digits in a property and redraw
//    on change.
// 3. Add a tap gesture on the view itself that calls `becomeFirstResponder()`, and check the `Bool` it returns.
// 4. `override var inputAccessoryView: UIView?` returning a lazily built `UIToolbar` — building a new one on every
//    access is a bug that shows up as a flickering accessory.
// 5. For dismissal call `endEditing(true)` on the container and write down what it actually does: it finds the current
//    first responder below it and asks it to resign.
// 6. Make `resignFirstResponder()` return `false` while the input is incomplete and watch the keyboard stay up.
//
// Done when
// - [ ] Typing changes the view's content
// - [ ] `becomeFirstResponder()` returns `true`, and you know the two things that make it return `false`
// - [ ] The accessory view is created once, not rebuilt on every access
// - [ ] A comment states the difference between `resignFirstResponder()` and `endEditing(_:)`
//
// Pitfall
// `becomeFirstResponder()` fails silently on a view that is not in a window yet, and on one whose
// `canBecomeFirstResponder` is `false`. Ignoring its `Bool` result is why "the keyboard doesn't open" costs an hour.
