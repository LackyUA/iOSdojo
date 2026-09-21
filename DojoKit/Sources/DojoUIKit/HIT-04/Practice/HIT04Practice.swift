// HIT-04 · Extend the tap area · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `final class ExpandedTouchButton: UIButton` with `var touchAreaInsets: UIEdgeInsets = .zero`, where negative
//    insets grow the area.
// 2. Override `point(inside:with:)` to test against the extended rect.
// 3. Add `var minimumTouchSize: CGSize = CGSize(width: 44, height: 44)` that grows the area symmetrically whenever the
//    button is smaller than the HIG minimum.
//
// Steps
// 1. `override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { touchRect.contains(point) }` — one
//    expression, no branching.
// 2. Compute `touchRect`: start from `bounds.inset(by: touchAreaInsets)`, then grow it around its own centre up to
//    `minimumTouchSize` with `insetBy(dx:dy:)` and a negative delta.
// 3. Invalidate nothing and cache nothing — `touchRect` is computed, because `bounds` changes on every layout pass.
// 4. Test without a simulator: `button.point(inside: CGPoint(x: -8, y: -8), with: nil)`, a point just outside the
//    extended rect, and all four corners.
// 5. Take a 24×24 icon button and assert every point of the 44×44 square around its centre hits.
// 6. Answer the parent question: does the extended area still work when the button sits flush against the edge of its
//    superview? Prove it with `superview.hitTest(...)` and write the answer in a comment.
//
// Done when
// - [ ] A 24×24 button answers `true` across the whole 44×44 area around its centre
// - [ ] `point(inside:)` is overridden rather than `hitTest`, and you can say why that is the right hook here
// - [ ] Negative insets grow the area and positive ones shrink it, both covered by an assertion
// - [ ] A comment records what happens when the enlarged area leaves the superview's bounds
//
// Pitfall
// Enlarging `point(inside:)` does nothing once the extra area falls outside the superview's bounds: the parent's own
// `point(inside:)` answers `false` first and the search never reaches the button. An extended tap target needs either
// room in the parent or `HIT-05`.
