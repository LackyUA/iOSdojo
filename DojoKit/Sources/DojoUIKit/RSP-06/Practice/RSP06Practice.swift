// RSP-06 · Routing through the chain · ⏱ 30 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Replace a three-level hand-off (cell → container view → view controller → coordinator) with a single event sent up
//    the responder chain.
// 2. `protocol RouteHandling { func handle(_ route: Route) -> Bool }` plus `extension UIResponder { func send(_ route:
//    Route) }` that walks `next` until somebody handles it.
// 3. Only the types that actually handle a route conform; every view in between stays untouched.
//
// Steps
// 1. Model the event as a value: `enum Route { case openProduct(ProductID), openCart, dismiss }`. No selectors, no
//    `@objc`, no stringly-typed names.
// 2. `send(_:)` walks `sequence(first: self, next: \.next)`, casts each responder to `RouteHandling` and stops at the
//    first one that returns `true`.
// 3. Do not conform `UIResponder` itself to `RouteHandling` with a default implementation and then "override" it in a
//    subclass: a method from a class extension is statically dispatched and cannot be overridden, and the conformance
//    the subclass inherits keeps pointing at the default. Write that version once, watch the event reach the wrong
//    implementation, then delete it. That is the kata's real lesson.
// 4. Conform the handling view controller: forward to the coordinator and return `true`; return `false` for routes it
//    does not own so they keep travelling.
// 5. Test on a synthetic chain — three `UIResponder` subclasses with `next` overridden, one of them conforming. Assert
//    the handler received the route, and that an unhandled route reaches the end of the chain. No UI involved.
// 6. End `send(_:)` with `assertionFailure` in debug so an unhandled route is loud.
// 7. In a comment, argue the other side: what a new reader loses when the call site and the handler are four levels
//    apart, and when a closure is still the better tool.
//
// Done when
// - [ ] The intermediate views contain no routing code at all
// - [ ] The implementation compiles with no `@objc` and no selectors
// - [ ] Routing is covered by a test over a synthetic chain
// - [ ] An unhandled route is detectable in debug, not silently dropped
// - [ ] A comment argues both sides honestly
//
// Pitfall
// The quiet failure is an event nobody claimed: the default forwarded it to a `nil` `next` and the tap did nothing.
// Terminate the chain explicitly, and remember that `handle` returning `Bool` is what makes "I did not want this one"
// expressible at all.
