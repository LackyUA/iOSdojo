// HIT-05 · Catch a touch outside the parent · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. A `container` with `clipsToBounds = false` and a `closeButton` whose frame hangs half-way outside the container's
//    bounds — the badge/close-button layout every design system ends up with.
// 2. Show first that the overhanging half does not respond.
// 3. Override `hitTest(_:with:)` on the container to give overflowing subviews a second chance.
//
// Steps
// 1. Prove the bug: `container.hitTest(pointInTheOverhang, with: nil)` returns `nil`, so from the window's point of
//    view the touch lands on whatever is behind the container.
// 2. In the container, override `hitTest`: call `super` first and return its result when it is non-`nil`. The normal
//    path must stay normal.
// 3. Only when `super` returned `nil`, loop over `subviews.reversed()`, convert the point with `subview.convert(point,
//    from: self)` and ask `subview.hitTest(converted, with: event)`. Return the first non-`nil`.
// 4. Guard that loop with the same rules the default has — skip hidden, `alpha < 0.01` and interaction-disabled
//    subviews — otherwise you resurrect touches UIKit deliberately dropped.
// 5. Assert that a point outside the container and outside every subview still returns `nil`.
//
// Done when
// - [ ] The overhanging half of the button hits the button
// - [ ] A point outside the container and all subviews returns `nil`
// - [ ] Hidden, disabled and transparent subviews are still ignored
// - [ ] A comment explains why `clipsToBounds` changes what you see but not what you can touch
//
// Pitfall
// Returning a subview for any point at all turns the container into a touch black hole: siblings underneath stop
// working and the bug surfaces three screens away. Always return `nil` when nothing matched.
