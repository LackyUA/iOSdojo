// RSP-01 · Walk the chain · ⏱ 5 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. `extension UIResponder { var responderChain: [UIResponder] }`, built by following `next`.
// 2. Print the chain from a deeply nested label inside a cell, and from a view inside a presented view controller.
// 3. Write down where the chain stops matching the view hierarchy.
//
// Steps
// 1. `sequence(first: self, next: \.next).map { $0 }` — one line. Write the `while` loop version too, then delete it.
// 2. Log `type(of:)` for each element and read the result: view → superview → … → the controller's view →
//    `UIViewController` → … → `UIWindow` → `UIApplication` → the app delegate.
// 3. Repeat from a view inside a `UINavigationController`'s child and note that the chain goes child VC → navigation
//    controller, never sideways to a sibling.
// 4. Repeat from a modally presented VC and find the presenting controller in the chain.
// 5. In a comment: which links are not views, and why a `UIViewController` is in the chain at all.
//
// Done when
// - [ ] The chain is produced with `sequence(first:next:)`
// - [ ] The printed chain ends at the app delegate
// - [ ] You can point at the two places where the chain leaves the view hierarchy
// - [ ] The nested-in-a-cell chain is written down in a comment
//
// Pitfall
// A view that is not in a window yet has a chain that stops at its topmost superview. Reading `next` from `init` or
// `awakeFromNib` tells you nothing — the chain only exists once the view has been added to a window.
