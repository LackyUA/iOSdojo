// HIT-05 · Catch a touch outside the parent · ⏱ 15 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// A container that also answers for the subviews hanging outside its own bounds.
///
/// `clipsToBounds = false` changes what is drawn, never what is touched: the default `hitTest(_:with:)` asks
/// `point(inside:with:)` first and gives up before it ever looks at a subview. This container gives the overflowing
/// subviews a second chance, and only a second chance — the normal path stays the default one.
final class OverflowingContainerView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // `self` first. `super.hitTest` is about to return `nil` for a hidden, disabled or transparent container, and
        // without this guard the loop below would resurrect exactly the touches UIKit meant to drop.
        guard !isHidden, isUserInteractionEnabled, alpha > 0.01 else {
            return nil
        }
        if let hit = super.hitTest(point, with: event) {
            return hit
        }
        // Only now, with the point outside this view's bounds, ask the subviews directly. No extra filtering: every
        // `subview.hitTest` applies the rejection rules to itself.
        for subview in subviews.reversed() {
            let converted = subview.convert(point, from: self)
            if let hit = subview.hitTest(converted, with: event) {
                return hit
            }
        }
        // Nothing matched. Returning anything else here — `self`, or the front-most subview — turns the container
        // into a touch black hole and breaks siblings that are nowhere near it.
        return nil
    }
}

/// The layout every design system arrives at eventually: a close button hanging over the container's corner.
@MainActor
struct OverhangingLayout {

    let root = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let container: UIView
    let closeButton = UIView(frame: CGRect(x: 180, y: -20, width: 40, height: 40))

    /// A point over the half of the close button that hangs outside the container, in `root` coordinates.
    static let overhang = CGPoint(x: 260, y: 40)

    /// A point over the half that is still inside the container, in `root` coordinates.
    static let insideHalf = CGPoint(x: 230, y: 60)

    /// A point over the container itself.
    static let plainContainer = CGPoint(x: 80, y: 100)

    /// A point far away from both.
    static let elsewhere = CGPoint(x: 20, y: 280)

    init(container: UIView) {
        self.container = container
        container.frame = CGRect(x: 50, y: 50, width: 200, height: 100)
        container.clipsToBounds = false
        root.addSubview(container)
        container.addSubview(closeButton)
    }

    func hitTest(_ point: CGPoint) -> UIView? {
        root.hitTest(point, with: nil)
    }
}

// MARK: - Checks

/// The overhang responds, and nothing else changes — the second half is what keeps the fix from becoming a bug.
@MainActor
enum HIT05Checks {

    static func run() {
        assertDefaultDropsTheOverhang()
        assertOverflowingContainerCatchesIt()
        assertNothingElseChanged()
        print("HIT-05 ✅ the overhanging half answers, and points that belong to nobody still return the root")
    }

    /// The bug, reproduced: a plain container never even asks the subview.
    private static func assertDefaultDropsTheOverhang() {
        let layout = OverhangingLayout(container: UIView())

        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        precondition(layout.container.hitTest(CGPoint(x: 210, y: -10), with: nil) == nil)
        // The half inside the container works, which is why the report always says "it only works on one side".
        precondition(layout.hitTest(OverhangingLayout.insideHalf) === layout.closeButton)
    }

    private static func assertOverflowingContainerCatchesIt() {
        let layout = OverhangingLayout(container: OverflowingContainerView())

        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.closeButton)
        precondition(layout.hitTest(OverhangingLayout.insideHalf) === layout.closeButton)
        precondition(layout.hitTest(OverhangingLayout.plainContainer) === layout.container)
    }

    /// The touches the container must keep letting through.
    private static func assertNothingElseChanged() {
        let layout = OverhangingLayout(container: OverflowingContainerView())

        // A point that belongs to nobody stays with the root.
        precondition(layout.hitTest(OverhangingLayout.elsewhere) === layout.root)
        precondition(layout.container.hitTest(CGPoint(x: -100, y: -100), with: nil) == nil)

        // The rejection rules still apply — to the subview…
        layout.closeButton.isHidden = true
        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        layout.closeButton.isHidden = false

        layout.closeButton.alpha = 0
        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        layout.closeButton.alpha = 1

        layout.closeButton.isUserInteractionEnabled = false
        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        layout.closeButton.isUserInteractionEnabled = true

        // …and to the container itself, which is the guard the naive version forgets.
        layout.container.isUserInteractionEnabled = false
        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        layout.container.isUserInteractionEnabled = true

        layout.container.isHidden = true
        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.root)
        layout.container.isHidden = false

        precondition(layout.hitTest(OverhangingLayout.overhang) === layout.closeButton)
    }
}

#endif
