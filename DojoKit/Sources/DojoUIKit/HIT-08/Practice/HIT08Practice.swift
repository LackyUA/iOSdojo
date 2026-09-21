// HIT-08 · From the hit-test view into the chain · ⏱ 15 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Show that the view returned by `hitTest` is where `touchesBegan(_:with:)` is delivered first.
// 2. Show that `UIResponder`'s default implementation forwards unhandled touches up the chain — and what breaks when an
//    override skips `super`.
// 3. Add a `UITapGestureRecognizer` on an ancestor and explain why it fires for a touch that landed on a descendant.
//
// Steps
// 1. Override `touchesBegan`, `touchesMoved`, `touchesEnded` and `touchesCancelled` in the deep view, in its container
//    and in the view controller, logging each one.
// 2. Tap the deep view and record the order. The touch reaches the view controller only because every override calls
//    `super`.
// 3. Remove one `super` call in the middle and run again: the chain stops there. That is what "the chain" means for
//    touches.
// 4. Attach a tap recognizer to the container and tap the child. The recognizer wins and the child receives
//    `touchesCancelled`.
// 5. Set `cancelsTouchesInView = false` and compare the two logs.
// 6. In a comment, separate the three mechanisms in one sentence each: hit testing picks which view, the responder
//    chain decides who ends up handling it, gesture recognizers sit above both and can cancel the delivery.
//
// Done when
// - [ ] The log shows `touchesBegan` arriving at the hit-test view first
// - [ ] Dropping one `super` call visibly truncates the chain
// - [ ] The recognizer on the ancestor fires for a touch on the descendant, and you can say why
// - [ ] You have seen `touchesCancelled` fire and know which property controls it
//
// Pitfall
// `touchesBegan` without `super` is the classic "my parent stopped getting taps" bug. `UIResponder`'s default
// implementation is not empty — it forwards to `next`. Skip `super` only when you mean to consume the touch.
