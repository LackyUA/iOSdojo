# Tasks · Part 6: Hit testing & the responder chain

`HIT` · `RSP` — 14 katas

> [!NOTE]
> Every kata here is UIKit. The modules live in `DojoKit/Sources/DojoUIKit/`, and the package also builds for macOS,
> so wrap your code in `#if canImport(UIKit)`.
>
> Hit testing is a **pure function of the view hierarchy**: you never need a touch, a simulator or a running app to
> exercise it. Build the views in code, call `hitTest(_:with:)` directly and assert on the result. Everything except
> `RSP-03` and `RSP-05` can be done in a unit test.
>
> Each reference solution ends with a `<ID>Checks` namespace holding every claim the kata makes as a `precondition`.
> Call `HIT01Checks.run()` from a `#Playground`, a test or a scene delegate to see the kata prove itself.

---

## HIT — Hit testing

### `HIT-01` · Trace the hit test ⏱ 5

**Task**
1. Build a three-level hierarchy: `root` (300×300) → `card` (200×200, inset) → `button` (100×44, inset).
2. Override `hitTest(_:with:)` and `point(inside:with:)` on each level to log the call and the result before returning `super`.
3. Probe three points — inside the button, inside the card but outside the button, inside the root only — and write the call order down.

**Steps**
1. Write one `final class TracingView: UIView` with a `name: String` and both overrides, then use three instances. Don't write the same override three times.
2. In `hitTest`, capture `let result = super.hitTest(point, with: event)` and log `"\(name).hitTest(\(point)) -> \(result?.name ?? "nil")"`.
3. Drive it without a simulator: `root.hitTest(CGPoint(x: 150, y: 150), with: nil)` straight from a test.
4. For each of the three points record how many `point(inside:)` calls happen, in what order the subviews are visited, and which view comes back.
5. Add a second `card` overlapping the first and confirm which of the two wins.
6. In a comment answer: why is `root.hitTest` called before `card.point(inside:)`, and why is the *deepest* matching view returned rather than the first container that contains the point?

**Done when**
- [ ] The log shows `hitTest` descending parent → child, with `point(inside:)` deciding at each level
- [ ] Overlapping siblings are visited front-to-back (`subviews.reversed()`), proven by the log
- [ ] The point inside the button returns the button, not the card
- [ ] You can state the algorithm in two sentences without looking at the code

**Pitfall** UIKit calls `hitTest(_:with:)` several times for a single touch, and again for every gesture recognizer. Anything with a side effect in the override — analytics, state changes, layout — fires far more often than you expect. Hit testing must stay a pure query.

---

### `HIT-02` · The four rejection rules ⏱ 5

**Task**
1. Take the hierarchy from `HIT-01`. Make the `card` fail, one at a time, each of the four conditions that stop hit testing: `isHidden`, low `alpha`, `isUserInteractionEnabled == false`, and the point being outside `bounds`.
2. Assert what `root.hitTest(pointInsideTheButton, with: nil)` returns in each case.
3. Record which of the four also make the *subviews* unreachable.

**Steps**
1. Four assertions, each restoring the view's state afterwards.
2. Find the alpha threshold empirically — try `0.0`, `0.005`, `0.01`, `0.02`. The documentation says a view with an alpha *below* 0.01 is ignored; confirm the boundary instead of trusting the number, and write down what you measured.
3. Set `isUserInteractionEnabled = false` on the card while the button inside it stays enabled. The button is unreachable, because the search never descends into the card.
4. Move the button so it sticks out of the card (`card.clipsToBounds = false`, so it is still visible) and probe the overhanging half.
5. In a comment: which of the four rules produce a view that is *visible but untappable*? That is the state that generates bug reports.

**Done when**
- [ ] Four assertions, one per rule, each with the expected return value spelled out
- [ ] The measured alpha threshold is written down, not guessed
- [ ] A disabled or hidden parent is shown to hide its interactive children
- [ ] A subview outside its parent's bounds is shown to be visible but never hit

**Pitfall** It is the view's `alpha` that counts, not what it draws: `backgroundColor = .clear` is fully hit-testable. "Invisible but tappable" and "visible but untappable" look identical on screen and have opposite causes.

---

### `HIT-03` · Write `hitTest` from scratch ⏱ 15

**Task**
1. `extension UIView { func dojoHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? }` — reimplement the default algorithm without calling `super.hitTest`.
2. Verify it against the real `hitTest(_:with:)` over a grid of points on a hierarchy with overlapping siblings.
3. Handle the case that trips most reimplementations: a subview with a non-identity `transform`.

**Steps**
1. Guard clauses first: `isHidden`, `isUserInteractionEnabled == false`, `alpha < 0.01` → `nil`.
2. `guard point(inside: point, with: event) else { return nil }`.
3. Iterate `subviews.reversed()` — the last subview is drawn on top, so it must be asked first.
4. Convert into the subview's coordinate space with `subview.convert(point, from: self)`, recurse, and return the first non-`nil` result.
5. Fall back to `self`.
6. Write the comparison test: a 20×20 grid of points over `root.bounds`, asserting `root.dojoHitTest(p, with: nil) === root.hitTest(p, with: nil)` for every point.
7. Add a subview with `transform = CGAffineTransform(rotationAngle: .pi / 6)` and one with a scale, then rerun the grid. It still passes only if you used `convert`.

**Done when**
- [ ] `dojoHitTest` contains no call to `super.hitTest`
- [ ] The grid test passes with overlapping siblings
- [ ] The grid test passes with a rotated and a scaled subview
- [ ] The traversal order is `reversed()` and you can say why in one sentence
- [ ] Recursion returns the deepest match, never the first container that contains the point

**Pitfall** `point - subview.frame.origin` works right up until something gets a `transform`, and then the tap area silently drifts away from the pixels. `frame` is meaningless for a transformed view; `convert(_:from:)` is the only conversion that accounts for the transform.

---

### `HIT-04` · Extend the tap area ⏱ 15

**Task**
1. `final class ExpandedTouchButton: UIButton` with `var touchAreaInsets: UIEdgeInsets = .zero`, where negative insets grow the area.
2. Override `point(inside:with:)` to test against the extended rect.
3. Add `var minimumTouchSize: CGSize = CGSize(width: 44, height: 44)` that grows the area symmetrically whenever the button is smaller than the HIG minimum.

**Steps**
1. `override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { touchRect.contains(point) }` — one expression, no branching.
2. Compute `touchRect`: start from `bounds.inset(by: touchAreaInsets)`, then grow it around its own centre up to `minimumTouchSize` with `insetBy(dx:dy:)` and a negative delta.
3. Invalidate nothing and cache nothing — `touchRect` is computed, because `bounds` changes on every layout pass.
4. Test without a simulator: `button.point(inside: CGPoint(x: -8, y: -8), with: nil)`, a point just outside the extended rect, and all four corners.
5. Take a 24×24 icon button and assert every point of the 44×44 square around its centre hits.
6. Answer the parent question: does the extended area still work when the button sits flush against the edge of its superview? Prove it with `superview.hitTest(...)` and write the answer in a comment.

**Done when**
- [ ] A 24×24 button answers `true` across the whole 44×44 area around its centre
- [ ] `point(inside:)` is overridden rather than `hitTest`, and you can say why that is the right hook here
- [ ] Negative insets grow the area and positive ones shrink it, both covered by an assertion
- [ ] A comment records what happens when the enlarged area leaves the superview's bounds

**Pitfall** Enlarging `point(inside:)` does nothing once the extra area falls outside the *superview's* bounds: the parent's own `point(inside:)` answers `false` first and the search never reaches the button. An extended tap target needs either room in the parent or `HIT-05`.

---

### `HIT-05` · Catch a touch outside the parent ⏱ 15

**Task**
1. A `container` with `clipsToBounds = false` and a `closeButton` whose frame hangs half-way outside the container's bounds — the badge/close-button layout every design system ends up with.
2. Show first that the overhanging half does not respond.
3. Override `hitTest(_:with:)` on the container to give overflowing subviews a second chance.

**Steps**
1. Prove the bug: `container.hitTest(pointInTheOverhang, with: nil)` returns `nil`, so from the window's point of view the touch lands on whatever is behind the container.
2. In the container, override `hitTest`: call `super` first and return its result when it is non-`nil`. The normal path must stay normal.
3. Only when `super` returned `nil`, loop over `subviews.reversed()`, convert the point with `subview.convert(point, from: self)` and ask `subview.hitTest(converted, with: event)`. Return the first non-`nil`.
4. Guard that loop with the same rules the default has — skip hidden, `alpha < 0.01` and interaction-disabled subviews — otherwise you resurrect touches UIKit deliberately dropped.
5. Assert that a point outside the container *and* outside every subview still returns `nil`.

**Done when**
- [ ] The overhanging half of the button hits the button
- [ ] A point outside the container and all subviews returns `nil`
- [ ] Hidden, disabled and transparent subviews are still ignored
- [ ] A comment explains why `clipsToBounds` changes what you *see* but not what you can *touch*

**Pitfall** Returning a subview for any point at all turns the container into a touch black hole: siblings underneath stop working and the bug surfaces three screens away. Always return `nil` when nothing matched.

---

### `HIT-06` · Pass-through overlay view ⏱ 15

**Task**
1. `final class PassthroughView: UIView` — an overlay that covers the whole screen but is tappable only where its own subviews are.
2. `hitTest` returns `nil` when the result is `self`, and the real view otherwise.
3. Use it as the root of a coach-mark or floating-banner overlay: the banner reacts, everything else falls through to the screen below.

**Steps**
1. `let view = super.hitTest(point, with: event); return view === self ? nil : view`. Three lines, no point arithmetic.
2. Put the overlay on top of a full-screen `backgroundView` holding a button, and assert that a point away from the banner returns that button.
3. Assert that a point on the banner returns the banner.
4. Try the two wrong alternatives and record why each fails: `isUserInteractionEnabled = false` on the overlay (kills the subviews too) and a plain transparent overlay (swallows everything).
5. Bonus: express the same thing as a `UIView` subclass versus a reusable modifier on any view, and pick one.

**Done when**
- [ ] A tap on empty overlay space reaches the view behind
- [ ] A tap on the banner reaches the banner
- [ ] The overlay itself never appears as a hit-test result
- [ ] A comment contrasts this with `isUserInteractionEnabled = false`

**Pitfall** `super.hitTest` still has to run. Returning `nil` before calling it disables the subviews as well — the check is on the *result*, not on the point.

---

### `HIT-07` · Pass-through `UIWindow` ⏱ 30

**Task**
1. `final class OverlayWindow: UIWindow` above the app's main window, hosting SwiftUI toasts through a `UIHostingController`.
2. Make the window transparent to touches everywhere except where a toast actually is, by overriding `point(inside:with:)`.
3. Mark the interactive regions with a dedicated marker type (`final class OverlayHitTestingView: UIView`) instead of guessing from frames.

**Steps**
1. Create the window on a `UIWindowScene`, set `windowLevel`, `rootViewController = UIHostingController(rootView:)`, `rootViewController?.view.backgroundColor = .clear`, `isHidden = false`, and keep a strong reference to it somewhere that outlives the call.
2. First version — a purely decorative window (confetti, animations): `override func point(inside:with:) -> Bool { false }`. Confirm the app underneath is fully usable.
3. Second version — recursive search: a private `point(inside:with:in view: UIView) -> Bool` that returns `view.isUserInteractionEnabled && view.point(inside: point, with: event)` when `view is OverlayHitTestingView`, otherwise converts the point into each subview and recurses, and returns `false` when nothing matched.
4. Plant the marker view underneath the toast's SwiftUI content with a `UIViewRepresentable` background, so the interactive region tracks the toast's real layout with no frame maths.
5. Verify both directions: a tap on the toast dismisses it, a tap one point outside reaches the button in the app below.
6. Check the lifetime: what keeps the window alive, and what happens to touches once you set `isHidden = true`.

**Done when**
- [ ] Touches outside the toast reach the main window, proven with a button underneath
- [ ] Touches on the toast reach the toast
- [ ] No hardcoded frames: moving the toast needs no change in the window
- [ ] The window outlives the function that created it, and a comment says what retains it
- [ ] A comment compares this with putting the overlay inside the main window's hierarchy

**Pitfall** A window's `point(inside:)` is asked about *every* touch in the app, so a full recursive walk of the hosted hierarchy on each call is a real cost — keep the tree shallow and return early. And a window retained by nothing but a local variable vanishes the moment the function returns, taking the overlay with it.

---

### `HIT-08` · From the hit-test view into the chain ⏱ 15

**Task**
1. Show that the view returned by `hitTest` is where `touchesBegan(_:with:)` is delivered first.
2. Show that `UIResponder`'s default implementation forwards unhandled touches up the chain — and what breaks when an override skips `super`.
3. Add a `UITapGestureRecognizer` on an ancestor and explain why it fires for a touch that landed on a descendant.

**Steps**
1. Override `touchesBegan`, `touchesMoved`, `touchesEnded` and `touchesCancelled` in the deep view, in its container and in the view controller, logging each one.
2. Tap the deep view and record the order. The touch reaches the view controller only because every override calls `super`.
3. Remove one `super` call in the middle and run again: the chain stops there. That is what "the chain" means for touches.
4. Attach a tap recognizer to the container and tap the child. The recognizer wins and the child receives `touchesCancelled`.
5. Set `cancelsTouchesInView = false` and compare the two logs.
6. In a comment, separate the three mechanisms in one sentence each: hit testing picks *which* view, the responder chain decides *who ends up handling it*, gesture recognizers sit above both and can cancel the delivery.

**Done when**
- [ ] The log shows `touchesBegan` arriving at the hit-test view first
- [ ] Dropping one `super` call visibly truncates the chain
- [ ] The recognizer on the ancestor fires for a touch on the descendant, and you can say why
- [ ] You have seen `touchesCancelled` fire and know which property controls it

**Pitfall** `touchesBegan` without `super` is the classic "my parent stopped getting taps" bug. `UIResponder`'s default implementation is not empty — it forwards to `next`. Skip `super` only when you mean to consume the touch.

---

## RSP — The responder chain

### `RSP-01` · Walk the chain ⏱ 5

**Task**
1. `extension UIResponder { var responderChain: [UIResponder] }`, built by following `next`.
2. Print the chain from a deeply nested label inside a cell, and from a view inside a presented view controller.
3. Write down where the chain stops matching the view hierarchy.

**Steps**
1. `sequence(first: self, next: \.next).map { $0 }` — one line. Write the `while` loop version too, then delete it.
2. Log `type(of:)` for each element and read the result: view → superview → … → the controller's view → `UIViewController` → … → `UIWindow` → `UIApplication` → the app delegate.
3. Repeat from a view inside a `UINavigationController`'s child and note that the chain goes child VC → navigation controller, never sideways to a sibling.
4. Repeat from a modally presented VC and find the presenting controller in the chain.
5. In a comment: which links are not views, and why a `UIViewController` is in the chain at all.

**Done when**
- [ ] The chain is produced with `sequence(first:next:)`
- [ ] The printed chain ends at the app delegate
- [ ] You can point at the two places where the chain leaves the view hierarchy
- [ ] The nested-in-a-cell chain is written down in a comment

**Pitfall** A view that is not in a window yet has a chain that stops at its topmost superview. Reading `next` from `init` or `awakeFromNib` tells you nothing — the chain only exists once the view has been added to a window.

---

### `RSP-02` · Find the first responder ⏱ 5

**Task**
1. Find the current first responder without recursing over `subviews`.
2. Use the nil-target trick: `UIApplication.shared.sendAction(_:to:nil,from:nil,for:)` with a handler that captures `self`.
3. Explain in a comment why `to: nil` finds it.

**Steps**
1. `@MainActor private static weak var found: UIResponder?` on a `UIResponder` extension, plus `@objc private func captureFirstResponder(_ sender: Any?) { UIResponder.found = self }`.
2. `static var current: UIResponder?` clears `found`, calls `sendAction(#selector(captureFirstResponder), to: nil, from: nil, for: nil)` and returns `found`.
3. Write the naive alternative — a recursive `subviews` walk checking `isFirstResponder` — and note that it misses responders that are not views, such as a view controller that became first responder.
4. Make a `UITextField` first responder in a test host, call both versions and compare.
5. In a comment, connect the trick to `target(forAction:withSender:)`: a `nil` target means "start at the first responder and walk up".

**Done when**
- [ ] The helper returns the text field that is currently first responder
- [ ] The static holder is cleared before every lookup, so a stale result is impossible
- [ ] The reference is `weak`
- [ ] A case is documented where the recursive-subview version gives a different answer

**Pitfall** The static holder is global mutable state; under strict concurrency it has to be main-actor isolated. And it must be `weak` — a strongly held first responder is a leaked view controller that nobody will attribute to this helper.

---

### `RSP-03` · A custom view that becomes first responder ⏱ 15

**Task**
1. `final class PinCodeView: UIView` that takes keyboard input: `canBecomeFirstResponder` plus `UIKeyInput`.
2. An `inputAccessoryView` with a Done button that resigns.
3. Dismissal on a tap outside, without the "tap anywhere kills the keyboard" sledgehammer.

**Steps**
1. `override var canBecomeFirstResponder: Bool { true }` — the default is `false`, and without it `becomeFirstResponder()` just returns `false`.
2. Conform to `UIKeyInput`: `hasText`, `insertText(_:)`, `deleteBackward()`. Keep the digits in a property and redraw on change.
3. Add a tap gesture on the view itself that calls `becomeFirstResponder()`, and check the `Bool` it returns.
4. `override var inputAccessoryView: UIView?` returning a lazily built `UIToolbar` — building a new one on every access is a bug that shows up as a flickering accessory.
5. For dismissal call `endEditing(true)` on the container and write down what it actually does: it finds the current first responder below it and asks it to resign.
6. Make `resignFirstResponder()` return `false` while the input is incomplete and watch the keyboard stay up.

**Done when**
- [ ] Typing changes the view's content
- [ ] `becomeFirstResponder()` returns `true`, and you know the two things that make it return `false`
- [ ] The accessory view is created once, not rebuilt on every access
- [ ] A comment states the difference between `resignFirstResponder()` and `endEditing(_:)`

**Pitfall** `becomeFirstResponder()` fails silently on a view that is not in a window yet, and on one whose `canBecomeFirstResponder` is `false`. Ignoring its `Bool` result is why "the keyboard doesn't open" costs an hour.

---

### `RSP-04` · A custom action up the chain ⏱ 15

**Task**
1. Declare an action a deep subview can send without knowing who handles it — an `@objc` method signature such as `didRequestRemove(_:)`.
2. Send it from a button inside a cell with `UIApplication.shared.sendAction(_:to:nil,from:self,for:)`.
3. Implement it on the view controller two levels up, and veto it from an intermediate view with `canPerformAction(_:withSender:)`.

**Steps**
1. Sender side: no delegate, no closure, no `target`. `sendAction(_:to:nil,from:sender,for:)` starts at `sender` and walks `next`.
2. Receiver side: an `@objc` method on the view controller. The selector must match exactly, `sender` argument included.
3. Add `override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool` on an intermediate view, return `false` for this action, and watch the event travel past it to the next handler.
4. Use `target(forAction:withSender:)` in a test to assert *who* would handle the action, without sending it.
5. Write the trade-off down: against a delegate and against a closure — what you lose (the compile-time guarantee that somebody handles it, and discoverability) and what you gain (no wiring through three layers).

**Done when**
- [ ] The button holds no reference to the view controller, direct or indirect
- [ ] `target(forAction:withSender:)` is asserted in a test, so routing is verified without UI
- [ ] Vetoing in `canPerformAction` demonstrably moves handling one step up
- [ ] A comment states when you would still pick a delegate

**Pitfall** The failure mode is a silent no-op: misspell the selector or forget `@objc` and `sendAction` simply returns `false`. Always check that `Bool`, and cover the routing with a `target(forAction:)` test.

---

### `RSP-05` · An edit menu through `canPerformAction` ⏱ 15

**Task**
1. Attach a `UIEditMenuInteraction` to a custom view and present the menu on a long press.
2. Filter the standard items with `canPerformAction(_:withSender:)`: allow `copy:`, deny `paste:`.
3. Add one custom item and handle it.

**Steps**
1. `addInteraction(UIEditMenuInteraction(delegate: self))` — iOS 16+. Note in a comment what it replaced (`UIMenuController`) and why the old API's global singleton was a problem.
2. The view has to be first responder for the menu to route its actions, so `canBecomeFirstResponder` comes back — call `becomeFirstResponder()` before presenting.
3. Inject the custom `UIAction` from `editMenuInteraction(_:menuFor:suggestedActions:)`.
4. `override func canPerformAction(_:withSender:)` returning `true` only for the selectors you actually implement and `super` otherwise. Watch the standard menu shrink.
5. Implement `override func copy(_ sender: Any?)` writing to `UIPasteboard.general`, and assert the pasteboard contents in a test.

**Done when**
- [ ] The menu appears on the custom view with Copy and without Paste
- [ ] `copy(_:)` actually puts the value on the pasteboard
- [ ] The custom item runs its handler
- [ ] A comment records why the view had to become first responder

**Pitfall** Returning `true` from `canPerformAction` for a selector nobody implements shows the item and then sends the action to a responder that has no such method — an unrecognized-selector crash at the moment the user taps it. The `true` branches and the implemented methods must stay in sync.

---

### `RSP-06` · Routing through the chain ⏱ 30

**Task**
1. Replace a three-level hand-off (cell → container view → view controller → coordinator) with a single event sent up the responder chain.
2. `protocol RouteHandling { func handle(_ route: Route) -> Bool }` plus `extension UIResponder { func send(_ route: Route) }` that walks `next` until somebody handles it.
3. Only the types that actually handle a route conform; every view in between stays untouched.

**Steps**
1. Model the event as a value: `enum Route { case openProduct(ProductID), openCart, dismiss }`. No selectors, no `@objc`, no stringly-typed names.
2. `send(_:)` walks `sequence(first: self, next: \.next)`, casts each responder to `RouteHandling` and stops at the first one that returns `true`.
3. Do **not** conform `UIResponder` itself to `RouteHandling` with a default implementation and then "override" it in a subclass: a method from a class extension is statically dispatched and cannot be overridden, and the conformance the subclass inherits keeps pointing at the default. Write that version once, watch the event reach the wrong implementation, then delete it. That is the kata's real lesson.
4. Conform the handling view controller: forward to the coordinator and return `true`; return `false` for routes it does not own so they keep travelling.
5. Test on a synthetic chain — three `UIResponder` subclasses with `next` overridden, one of them conforming. Assert the handler received the route, and that an unhandled route reaches the end of the chain. No UI involved.
6. End `send(_:)` with `assertionFailure` in debug so an unhandled route is loud.
7. In a comment, argue the other side: what a new reader loses when the call site and the handler are four levels apart, and when a closure is still the better tool.

**Done when**
- [ ] The intermediate views contain no routing code at all
- [ ] The implementation compiles with no `@objc` and no selectors
- [ ] Routing is covered by a test over a synthetic chain
- [ ] An unhandled route is detectable in debug, not silently dropped
- [ ] A comment argues both sides honestly

**Pitfall** The quiet failure is an event nobody claimed: the default forwarded it to a `nil` `next` and the tap did nothing. Terminate the chain explicitly, and remember that `handle` returning `Bool` is what makes "I did not want this one" expressible at all.
