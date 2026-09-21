// HIT-03 · Write `hitTest` from scratch · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `extension UIView { func dojoHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? }` — reimplement the
//    default algorithm without calling `super.hitTest`.
// 2. Verify it against the real `hitTest(_:with:)` over a grid of points on a hierarchy with overlapping siblings.
// 3. Handle the case that trips most reimplementations: a subview with a non-identity `transform`.
//
// Steps
// 1. Guard clauses first: `isHidden`, `isUserInteractionEnabled == false`, `alpha < 0.01` → `nil`.
// 2. `guard point(inside: point, with: event) else { return nil }`.
// 3. Iterate `subviews.reversed()` — the last subview is drawn on top, so it must be asked first.
// 4. Convert into the subview's coordinate space with `subview.convert(point, from: self)`, recurse, and return the
//    first non-`nil` result.
// 5. Fall back to `self`.
// 6. Write the comparison test: a 20×20 grid of points over `root.bounds`, asserting `root.dojoHitTest(p, with: nil)
//    === root.hitTest(p, with: nil)` for every point.
// 7. Add a subview with `transform = CGAffineTransform(rotationAngle: .pi / 6)` and one with a scale, then rerun the
//    grid. It still passes only if you used `convert`.
//
// Done when
// - [ ] `dojoHitTest` contains no call to `super.hitTest`
// - [ ] The grid test passes with overlapping siblings
// - [ ] The grid test passes with a rotated and a scaled subview
// - [ ] The traversal order is `reversed()` and you can say why in one sentence
// - [ ] Recursion returns the deepest match, never the first container that contains the point
//
// Pitfall
// `point - subview.frame.origin` works right up until something gets a `transform`, and then the tap area silently
// drifts away from the pixels. `frame` is meaningless for a transformed view; `convert(_:from:)` is the only conversion
// that accounts for the transform.
