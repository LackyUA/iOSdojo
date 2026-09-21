// HIT-08 · From the hit-test view into the chain · ⏱ 15 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// The responders a touch passed through, in order.
@MainActor
final class TouchTrace {

    private(set) var receivers: [String] = []

    func record(_ receiver: String) {
        receivers.append(receiver)
    }

    func reset() {
        receivers.removeAll()
    }
}

/// A view that records the touch phases it is sent, and forwards them unless it is told to consume them.
final class TouchLoggingView: UIView {

    let name: String

    /// When `false` the override stops calling `super`, which is the whole difference between "handling a touch" and
    /// "handling a touch and breaking every ancestor that wanted it".
    var forwardsTouches = true

    init(name: String, frame: CGRect, trace: TouchTrace) {
        self.name = name
        self.trace = trace
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        trace.record(name)
        // `UIResponder`'s implementation is not empty: it passes the touch to `next`. Skipping it consumes the event.
        guard forwardsTouches else {
            return
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        trace.record("\(name).ended")
        guard forwardsTouches else {
            return
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        trace.record("\(name).cancelled")
        guard forwardsTouches else {
            return
        }
        super.touchesCancelled(touches, with: event)
    }

    // MARK: - Private Properties

    private let trace: TouchTrace
}

/// The end of the chain for this kata: a controller that records what reached it.
final class TouchLoggingViewController: UIViewController {

    init(trace: TouchTrace) {
        self.trace = trace
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        trace.record("controller")
        super.touchesBegan(touches, with: event)
    }

    // MARK: - Private Properties

    private let trace: TouchTrace
}

/// A controller with a container and a leaf inside it, all recording into one trace.
@MainActor
struct TouchHierarchy {

    let trace: TouchTrace
    let controller: TouchLoggingViewController
    let container: TouchLoggingView
    let leaf: TouchLoggingView

    /// A point over the leaf, in the controller's root view coordinates.
    static let onLeaf = CGPoint(x: 120, y: 120)

    init() {
        let trace = TouchTrace()
        controller = TouchLoggingViewController(trace: trace)
        container = TouchLoggingView(
            name: "container",
            frame: CGRect(x: 40, y: 40, width: 200, height: 200),
            trace: trace
        )
        leaf = TouchLoggingView(name: "leaf", frame: CGRect(x: 40, y: 40, width: 100, height: 100), trace: trace)
        self.trace = trace
        controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        controller.view.addSubview(container)
        container.addSubview(leaf)
    }

    /// The responders from `responder` up to the end of the chain.
    func chain(from responder: UIResponder) -> [UIResponder] {
        Array(sequence(first: responder, next: \.next))
    }
}

// MARK: - Checks

/// Hit testing picks the view; the responder chain decides who ends up handling it.
///
/// The checks deliver a bare `UITouch()` by hand. It belongs to no window and no view, and UIKit's default
/// implementations still forward it up the chain — which is exactly the behaviour under test. An empty set does not
/// work, and the reason is worth keeping: the default implementation forwards the touches it is given, and with none
/// to forward it has nothing to do.
@MainActor
enum HIT08Checks {

    static func run() {
        assertTheHitTestViewIsWhereDeliveryStarts()
        assertTheChainCarriesTheTouchUp()
        assertSkippingSuperTruncatesTheChain()
        assertRecognizerSitsAboveBoth()
        print("HIT-08 ✅ the hit-test view receives first, `super` carries the touch up, a recognizer can cut it short")
    }

    /// The view `hitTest` returns is the one `touchesBegan` is sent to first.
    private static func assertTheHitTestViewIsWhereDeliveryStarts() {
        let views = TouchHierarchy()

        precondition(views.controller.view.hitTest(TouchHierarchy.onLeaf, with: nil) === views.leaf)

        deliverTouchBegan(to: views.leaf)
        precondition(views.trace.receivers.first == "leaf")
    }

    /// Every `super` call is one step up the chain, and the chain is not the view hierarchy: after the root view
    /// comes the view controller, which is not a view at all.
    private static func assertTheChainCarriesTheTouchUp() {
        let views = TouchHierarchy()

        precondition(views.leaf.next === views.container)
        precondition(views.container.next === views.controller.view)
        precondition(views.controller.view.next === views.controller)
        // Not in a window yet, so the chain stops at the controller instead of reaching `UIApplication`.
        precondition(views.controller.next == nil)
        precondition(views.chain(from: views.leaf).count == 4)

        deliverTouchBegan(to: views.leaf)
        precondition(views.trace.receivers == ["leaf", "container", "controller"])
    }

    /// The classic "my parent stopped getting taps" bug, in three lines.
    private static func assertSkippingSuperTruncatesTheChain() {
        let views = TouchHierarchy()
        views.container.forwardsTouches = false

        deliverTouchBegan(to: views.leaf)
        precondition(views.trace.receivers == ["leaf", "container"])
        // The controller is still in the chain — it is simply never reached.
        precondition(views.chain(from: views.leaf).contains { $0 === views.controller })
    }

    /// A recognizer on an ancestor fires for a touch on a descendant: UIKit collects the recognizers of the hit-test
    /// view *and of every view above it*, and delivers the touch to them alongside the view.
    /// Hands a responder a touch the way UIKit would, minus the hardware.
    private static func deliverTouchBegan(to responder: UIResponder) {
        responder.touchesBegan([UITouch()], with: nil)
    }

    private static func assertRecognizerSitsAboveBoth() {
        let views = TouchHierarchy()
        let recognizer = UITapGestureRecognizer()
        views.container.addGestureRecognizer(recognizer)

        let hitView = views.controller.view.hitTest(TouchHierarchy.onLeaf, with: nil)
        precondition(hitView === views.leaf)
        precondition(recognizer.view === views.container)
        // The recognizer's view is an ancestor of the hit-test view, which is the whole reason it is involved.
        precondition(sequence(first: views.leaf as UIView, next: \.superview).contains { $0 === recognizer.view })

        // And once it recognizes, the view it sits above gets `touchesCancelled` instead of `touchesEnded` — the
        // default, and the reason a button inside a tappable cell stops highlighting.
        precondition(recognizer.cancelsTouchesInView)
        recognizer.cancelsTouchesInView = false
        precondition(!recognizer.cancelsTouchesInView)
    }
}

#endif
