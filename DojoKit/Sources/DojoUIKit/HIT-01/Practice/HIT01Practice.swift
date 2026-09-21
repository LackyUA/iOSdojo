// HIT-01 · Trace the hit test · ⏱ 5 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Build a three-level hierarchy: `root` (300×300) → `card` (200×200, inset) → `button` (100×44, inset).
// 2. Override `hitTest(_:with:)` and `point(inside:with:)` on each level to log the call and the result before
//    returning `super`.
// 3. Probe three points — inside the button, inside the card but outside the button, inside the root only — and write
//    the call order down.
//
// Steps
// 1. Write one `final class TracingView: UIView` with a `name: String` and both overrides, then use three instances.
//    Don't write the same override three times.
// 2. In `hitTest`, capture `let result = super.hitTest(point, with: event)` and log `"\(name).hitTest(\(point)) ->
//    \(result?.name ?? "nil")"`.
// 3. Drive it without a simulator: `root.hitTest(CGPoint(x: 150, y: 150), with: nil)` straight from a test.
// 4. For each of the three points record how many `point(inside:)` calls happen, in what order the subviews are
//    visited, and which view comes back.
// 5. Add a second `card` overlapping the first and confirm which of the two wins.
// 6. In a comment answer: why is `root.hitTest` called before `card.point(inside:)`, and why is the deepest matching
//    view returned rather than the first container that contains the point?
//
// Done when
// - [ ] The log shows `hitTest` descending parent → child, with `point(inside:)` deciding at each level
// - [ ] Overlapping siblings are visited front-to-back (`subviews.reversed()`), proven by the log
// - [ ] The point inside the button returns the button, not the card
// - [ ] You can state the algorithm in two sentences without looking at the code
//
// Pitfall
// UIKit calls `hitTest(_:with:)` several times for a single touch, and again for every gesture recognizer. Anything
// with a side effect in the override — analytics, state changes, layout — fires far more often than you expect. Hit
// testing must stay a pure query.
