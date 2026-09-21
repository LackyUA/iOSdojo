// HIT-07 · Pass-through `UIWindow` · ⏱ 30 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `final class OverlayWindow: UIWindow` above the app's main window, hosting SwiftUI toasts through a
//    `UIHostingController`.
// 2. Make the window transparent to touches everywhere except where a toast actually is, by overriding
//    `point(inside:with:)`.
// 3. Mark the interactive regions with a dedicated marker type (`final class OverlayHitTestingView: UIView`) instead of
//    guessing from frames.
//
// Steps
// 1. Create the window on a `UIWindowScene`, set `windowLevel`, `rootViewController = UIHostingController(rootView:)`,
//    `rootViewController?.view.backgroundColor = .clear`, `isHidden = false`, and keep a strong reference to it
//    somewhere that outlives the call.
// 2. First version — a purely decorative window (confetti, animations): `override func point(inside:with:) -> Bool {
//    false }`. Confirm the app underneath is fully usable.
// 3. Second version — recursive search: a private `point(inside:with:in view: UIView) -> Bool` that returns
//    `view.isUserInteractionEnabled && view.point(inside: point, with: event)` when `view is OverlayHitTestingView`,
//    otherwise converts the point into each subview and recurses, and returns `false` when nothing matched.
// 4. Plant the marker view underneath the toast's SwiftUI content with a `UIViewRepresentable` background, so the
//    interactive region tracks the toast's real layout with no frame maths.
// 5. Verify both directions: a tap on the toast dismisses it, a tap one point outside reaches the button in the app
//    below.
// 6. Check the lifetime: what keeps the window alive, and what happens to touches once you set `isHidden = true`.
//
// Done when
// - [ ] Touches outside the toast reach the main window, proven with a button underneath
// - [ ] Touches on the toast reach the toast
// - [ ] No hardcoded frames: moving the toast needs no change in the window
// - [ ] The window outlives the function that created it, and a comment says what retains it
// - [ ] A comment compares this with putting the overlay inside the main window's hierarchy
//
// Pitfall
// A window's `point(inside:)` is asked about every touch in the app, so a full recursive walk of the hosted hierarchy
// on each call is a real cost — keep the tree shallow and return early. And a window retained by nothing but a local
// variable vanishes the moment the function returns, taking the overlay with it.
