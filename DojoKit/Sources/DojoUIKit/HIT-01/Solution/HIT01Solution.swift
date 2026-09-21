// HIT-01 · Trace the hit test · ⏱ 5 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// The steps `hitTest(_:with:)` took, recorded instead of printed.
///
/// UIKit asks a view hierarchy to hit-test the same touch several times — once for the touch itself and again for
/// every gesture recognizer involved. A `print` in the override is therefore noisy and a side effect in it is a bug.
/// Recording into a buffer the caller resets keeps the override what it has to be: a pure query.
@MainActor
final class HitTestTrace {

    /// One step of the algorithm, as it happened.
    enum Step: Equatable {

        /// `hitTest(_:with:)` was entered on `view`, with the point in that view's own coordinates.
        case enter(view: String, point: CGPoint)

        /// `point(inside:with:)` answered `isInside` on `view`.
        case pointInside(view: String, point: CGPoint, isInside: Bool)

        /// `hitTest(_:with:)` on `view` returned `result`.
        case exit(view: String, result: String?)
    }

    private(set) var steps: [Step] = []

    /// The views `hitTest(_:with:)` was called on, in order — the shape of the descent.
    var visitedViews: [String] {
        steps.compactMap { step in
            guard case .enter(let view, _) = step else {
                return nil
            }
            return view
        }
    }

    /// The trace as an indented transcript, one line per call.
    var transcript: String {
        var depth = 0
        var lines: [String] = []
        for step in steps {
            switch step {
            case .enter(let view, let point):
                lines.append(String(repeating: "  ", count: depth) + "→ \(view).hitTest\(point.traced)")
                depth += 1
            case .pointInside(let view, let point, let isInside):
                lines.append(String(repeating: "  ", count: depth) + "\(view).point(inside:)\(point.traced) → \(isInside)")
            case .exit(let view, let result):
                depth = max(0, depth - 1)
                lines.append(String(repeating: "  ", count: depth) + "← \(view).hitTest → \(result ?? "nil")")
            }
        }
        return lines.joined(separator: "\n")
    }

    func record(_ step: Step) {
        steps.append(step)
    }

    func reset() {
        steps.removeAll()
    }
}

/// A view that records both halves of the algorithm before answering.
final class TracingView: UIView {

    let name: String

    init(name: String, frame: CGRect, trace: HitTestTrace) {
        self.name = name
        self.trace = trace
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        trace.record(.enter(view: name, point: point))
        // `super` is the entire algorithm: the rejection rules, `point(inside:with:)`, then the subviews from the
        // front-most backwards. Everything around it here is bookkeeping.
        let result = super.hitTest(point, with: event)
        trace.record(.exit(view: name, result: (result as? TracingView)?.name))
        return result
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        trace.record(.pointInside(view: name, point: point, isInside: isInside))
        return isInside
    }

    // MARK: - Private Properties

    private let trace: HitTestTrace
}

/// The three-level hierarchy the kata probes: `root` → `card` → `button`.
@MainActor
struct TracedHierarchy {

    let trace: HitTestTrace
    let root: TracingView
    let card: TracingView
    let button: TracingView

    /// A point over the button, in `root` coordinates.
    static let insideButton = CGPoint(x: 120, y: 140)

    /// A point over the card but outside the button, in `root` coordinates.
    static let insideCardOnly = CGPoint(x: 60, y: 60)

    /// A point over the root only, in `root` coordinates.
    static let insideRootOnly = CGPoint(x: 10, y: 10)

    /// A point outside the root, in `root` coordinates.
    static let outsideRoot = CGPoint(x: -10, y: 10)

    init() {
        let trace = HitTestTrace()
        root = TracingView(name: "root", frame: CGRect(x: 0, y: 0, width: 300, height: 300), trace: trace)
        card = TracingView(name: "card", frame: CGRect(x: 50, y: 50, width: 200, height: 200), trace: trace)
        button = TracingView(name: "button", frame: CGRect(x: 50, y: 78, width: 100, height: 44), trace: trace)
        self.trace = trace
        root.addSubview(card)
        card.addSubview(button)
    }

    /// Hit-tests `point` on `root` with an empty trace, so the recorded steps belong to this call alone.
    func hitTest(_ point: CGPoint) -> TracingView? {
        trace.reset()
        return root.hitTest(point, with: nil) as? TracingView
    }
}

/// Two siblings that overlap, to read the order in which they are asked.
@MainActor
struct TracedSiblings {

    let trace: HitTestTrace
    let container: TracingView
    let back: TracingView
    let front: TracingView

    /// A point covered by both siblings.
    static let inOverlap = CGPoint(x: 80, y: 80)

    /// A point covered by the back sibling only.
    static let inBackOnly = CGPoint(x: 20, y: 20)

    init() {
        let trace = HitTestTrace()
        container = TracingView(name: "container", frame: CGRect(x: 0, y: 0, width: 200, height: 200), trace: trace)
        back = TracingView(name: "back", frame: CGRect(x: 0, y: 0, width: 120, height: 120), trace: trace)
        front = TracingView(name: "front", frame: CGRect(x: 60, y: 60, width: 120, height: 120), trace: trace)
        self.trace = trace
        // `front` is added last, so it is drawn on top — and asked first.
        container.addSubview(back)
        container.addSubview(front)
    }

    func hitTest(_ point: CGPoint) -> TracingView? {
        trace.reset()
        return container.hitTest(point, with: nil) as? TracingView
    }
}

extension CGPoint {

    /// `(12, 34)` — short enough to keep a transcript line readable.
    fileprivate var traced: String {
        "(\(Int(x.rounded())), \(Int(y.rounded())))"
    }
}

// MARK: - Checks

/// Everything this kata claims, as assertions. Hit testing is a pure function of the hierarchy, so none of this needs
/// a touch, a window or a running screen — call `run()` from a `#Playground`, a test or a scene delegate.
@MainActor
enum HIT01Checks {

    static func run() {
        let views = TracedHierarchy()

        // Inside the button: the *deepest* view that contains the point wins, not the first container that does.
        precondition(views.hitTest(TracedHierarchy.insideButton) === views.button)
        // The descent is parent → child, one `hitTest` per level.
        precondition(views.trace.visitedViews == ["root", "card", "button"])
        print(views.trace.transcript)

        // Inside the card only: the button is still *asked*. A parent hit-tests every subview and lets each one
        // reject the point itself — that is why the algorithm needs no knowledge of where the subviews are.
        precondition(views.hitTest(TracedHierarchy.insideCardOnly) === views.card)
        precondition(views.trace.visitedViews == ["root", "card", "button"])

        // Inside the root only: the card is asked and rejects, so the root returns itself.
        precondition(views.hitTest(TracedHierarchy.insideRootOnly) === views.root)
        precondition(views.trace.visitedViews == ["root", "card"])

        // Outside the root: `point(inside:with:)` fails at the top and no subview is ever asked.
        precondition(views.hitTest(TracedHierarchy.outsideRoot) == nil)
        precondition(views.trace.visitedViews == ["root"])

        assertSiblingOrder()
        print("HIT-01 ✅ the algorithm: reject, contain, then ask the subviews front to back; the deepest match wins")
    }

    /// Siblings are asked in `subviews.reversed()` order, so the one drawn on top answers first.
    private static func assertSiblingOrder() {
        let siblings = TracedSiblings()

        // In the overlap the front sibling claims the point and the back one is never asked.
        precondition(siblings.hitTest(TracedSiblings.inOverlap) === siblings.front)
        precondition(siblings.trace.visitedViews == ["container", "front"])

        // Outside it, the front sibling is still asked first — it just rejects the point.
        precondition(siblings.hitTest(TracedSiblings.inBackOnly) === siblings.back)
        precondition(siblings.trace.visitedViews == ["container", "front", "back"])
    }
}

#endif
