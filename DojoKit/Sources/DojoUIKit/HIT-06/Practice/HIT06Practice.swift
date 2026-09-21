// HIT-06 · Pass-through overlay view · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `final class PassthroughView: UIView` — an overlay that covers the whole screen but is tappable only where its own
//    subviews are.
// 2. `hitTest` returns `nil` when the result is `self`, and the real view otherwise.
// 3. Use it as the root of a coach-mark or floating-banner overlay: the banner reacts, everything else falls through to
//    the screen below.
//
// Steps
// 1. `let view = super.hitTest(point, with: event); return view === self ? nil : view`. Three lines, no point
//    arithmetic.
// 2. Put the overlay on top of a full-screen `backgroundView` holding a button, and assert that a point away from the
//    banner returns that button.
// 3. Assert that a point on the banner returns the banner.
// 4. Try the two wrong alternatives and record why each fails: `isUserInteractionEnabled = false` on the overlay (kills
//    the subviews too) and a plain transparent overlay (swallows everything).
// 5. Bonus: express the same thing as a `UIView` subclass versus a reusable modifier on any view, and pick one.
//
// Done when
// - [ ] A tap on empty overlay space reaches the view behind
// - [ ] A tap on the banner reaches the banner
// - [ ] The overlay itself never appears as a hit-test result
// - [ ] A comment contrasts this with `isUserInteractionEnabled = false`
//
// Pitfall
// `super.hitTest` still has to run. Returning `nil` before calling it disables the subviews as well — the check is on
// the result, not on the point.
