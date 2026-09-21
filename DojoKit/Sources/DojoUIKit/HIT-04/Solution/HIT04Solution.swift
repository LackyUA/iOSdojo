// HIT-04 · Extend the tap area · ⏱ 15 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// A button whose touch area is not tied to what it draws.
///
/// `point(inside:with:)` is the hook, not `hitTest(_:with:)`: it answers the single question "is this point mine?",
/// which is exactly the question being changed. Overriding `hitTest` instead would mean reimplementing the descent
/// into subviews — all of HIT-03 — to change one rectangle.
final class ExpandedTouchButton: UIButton {

    /// Applied to `bounds` to get the touch area. Negative insets grow it, positive ones shrink it.
    var touchAreaInsets: UIEdgeInsets = .zero

    /// The smallest touch area the button is allowed to have, grown symmetrically around the inset rect.
    ///
    /// 44×44 is the Human Interface Guidelines minimum. Set it to `.zero` to opt out and use `touchAreaInsets` alone.
    var minimumTouchSize = CGSize(width: 44, height: 44)

    /// The rect that answers touches, in the button's own coordinates.
    ///
    /// Computed and never cached: `bounds` changes on every layout pass, and a stored rect would quietly go stale.
    var touchArea: CGRect {
        let inset = bounds.inset(by: touchAreaInsets)
        guard !inset.isNull else {
            return .null
        }
        return inset.insetBy(
            dx: min(0, (inset.width - minimumTouchSize.width) / 2),
            dy: min(0, (inset.height - minimumTouchSize.height) / 2)
        )
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        touchArea.contains(point)
    }
}

// MARK: - Checks

/// The tap area grows, shrinks, and stops at the parent's edge — the last one is the part that gets shipped broken.
@MainActor
enum HIT04Checks {

    static func run() {
        assertMinimumSize()
        assertInsets()
        assertParentClipsTheTouchArea()
        print("HIT-04 ✅ a 24×24 button answers over 44×44 — unless its parent has no room for the extra area")
    }

    /// A 24×24 icon button answers across the whole 44×44 square around its centre.
    private static func assertMinimumSize() {
        let parent = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let button = ExpandedTouchButton(frame: CGRect(x: 88, y: 88, width: 24, height: 24))
        parent.addSubview(button)

        precondition(button.touchArea == CGRect(x: -10, y: -10, width: 44, height: 44))

        // Every point of the 44×44 area hits, in the button's coordinates and through the parent alike.
        for x in stride(from: -10, through: 33, by: 1) {
            for y in stride(from: -10, through: 33, by: 1) {
                precondition(button.point(inside: CGPoint(x: x, y: y), with: nil))
                precondition(parent.hitTest(CGPoint(x: 88 + x, y: 88 + y), with: nil) === button)
            }
        }

        // And one point outside it does not.
        precondition(!button.point(inside: CGPoint(x: -11, y: 12), with: nil))
        precondition(parent.hitTest(CGPoint(x: 77, y: 100), with: nil) === parent)
    }

    /// Negative insets grow the area, positive ones shrink it — once the 44×44 floor is out of the way.
    private static func assertInsets() {
        let button = ExpandedTouchButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))

        button.touchAreaInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
        precondition(button.touchArea == CGRect(x: -8, y: -8, width: 116, height: 76))

        // With the floor in place, shrinking below 44 points does nothing: the height is pushed back to 44 around
        // the inset rect's own centre, so the area reaches from y = 8 — two points above where the insets asked.
        button.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        precondition(button.touchArea == CGRect(x: 10, y: 8, width: 80, height: 44))

        button.minimumTouchSize = .zero
        precondition(button.touchArea == CGRect(x: 10, y: 10, width: 80, height: 40))
    }

    /// The pitfall: the extra area only exists where the superview also answers for it.
    private static func assertParentClipsTheTouchArea() {
        let parent = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let flush = ExpandedTouchButton(frame: CGRect(x: 0, y: 88, width: 24, height: 24))
        parent.addSubview(flush)

        // The button says yes to the point 8 to its left…
        precondition(flush.point(inside: CGPoint(x: -8, y: 12), with: nil))

        // …and nobody ever asks it, because the parent rejected the point first.
        precondition(parent.hitTest(CGPoint(x: -8, y: 100), with: nil) == nil)

        // Give the parent room and the same touch lands: the fix is layout, not another override.
        let padded = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let inset = ExpandedTouchButton(frame: CGRect(x: 10, y: 88, width: 24, height: 24))
        padded.addSubview(inset)
        precondition(padded.hitTest(CGPoint(x: 2, y: 100), with: nil) === inset)
    }
}

#endif
