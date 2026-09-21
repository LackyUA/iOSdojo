// HIT-03 · Write `hitTest` from scratch · ⏱ 15 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

extension UIView {

    /// `UIView.hitTest(_:with:)`, written out: the deepest descendant that contains `point`, or `nil`.
    ///
    /// - Parameter point: the point in this view's own coordinate system.
    func dojoHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // The rules from HIT-02. Each one stops the search here rather than skipping a single view, which is what
        // makes a hidden or disabled parent hide its interactive children.
        guard !isHidden, isUserInteractionEnabled, alpha > Constants.hitTestableAlphaCutOff else {
            return nil
        }
        guard self.point(inside: point, with: event) else {
            return nil
        }
        // Back to front: the last subview is drawn on top, so it is asked first. Every subview is asked — the parent
        // needs no idea where they are, because each one rejects the point on its own.
        for subview in subviews.reversed() {
            // `convert` rather than `point - subview.frame.origin`: `frame` is the bounding box of a transformed
            // view, so subtracting its origin puts the tap area somewhere the pixels are not.
            let converted = subview.convert(point, from: self)
            if let hit = subview.dojoHitTest(converted, with: event) {
                return hit
            }
        }
        // Nothing deeper claimed the point, so the deepest view containing it is this one.
        return self
    }
}

private enum Constants {

    /// Measured in HIT-02: at this alpha the view is already ignored, just above it it is hit-tested again.
    static let hitTestableAlphaCutOff: CGFloat = 0.01
}

/// A hierarchy with every case that separates a real reimplementation from a plausible one.
@MainActor
struct MixedHierarchy {

    let root = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    init() {
        let back = UIView(frame: CGRect(x: 20, y: 20, width: 160, height: 160))
        let front = UIView(frame: CGRect(x: 120, y: 120, width: 160, height: 160))

        // A rotated view: its `frame` is now the bounding box of the rotated `bounds`, and only `convert` knows that.
        let rotated = UIView(frame: CGRect(x: 40, y: 200, width: 120, height: 60))
        rotated.transform = CGAffineTransform(rotationAngle: .pi / 6)

        // A scaled view with a child, so the conversion has to compose down two levels.
        let scaled = UIView(frame: CGRect(x: 180, y: 20, width: 100, height: 100))
        scaled.transform = CGAffineTransform(scaleX: 0.5, y: 1.5)
        let scaledChild = UIView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        scaled.addSubview(scaledChild)

        // The three views that must never be returned, each above a sibling that must be.
        let hidden = UIView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        hidden.isHidden = true
        let transparent = UIView(frame: CGRect(x: 90, y: 20, width: 60, height: 60))
        transparent.alpha = 0
        let disabled = UIView(frame: CGRect(x: 20, y: 90, width: 60, height: 60))
        disabled.isUserInteractionEnabled = false

        for subview in [back, front, rotated, scaled, hidden, transparent, disabled] {
            root.addSubview(subview)
        }
    }
}

// MARK: - Checks

/// Parity with UIKit over a grid of points — the only honest way to claim the reimplementation is the same algorithm.
@MainActor
enum HIT03Checks {

    static func run() {
        let views = MixedHierarchy()
        let points = probePoints(over: views.root.bounds)

        let mismatches = points.filter { point in
            views.root.dojoHitTest(point, with: nil) !== views.root.hitTest(point, with: nil)
        }
        precondition(mismatches.isEmpty, "\(mismatches.count) of \(points.count) points disagree with UIKit")

        // A grid that only ever answers `nil` would pass the check above and prove nothing.
        let resolved = Set(
            points.compactMap { point in
                views.root.dojoHitTest(point, with: nil).map(ObjectIdentifier.init)
            }
        )
        precondition(resolved.count >= 5, "the hierarchy has to exercise more than one branch")
        precondition(points.contains { views.root.dojoHitTest($0, with: nil) == nil }, "and some misses too")

        print("HIT-03 ✅ \(points.count) points, \(resolved.count) distinct views, 0 disagreements with UIKit")
    }

    /// A dense grid over `bounds`, sampled at pixel centres, plus the edges and a ring of points outside.
    private static func probePoints(over bounds: CGRect, resolution: Int = 40) -> [CGPoint] {
        var points: [CGPoint] = []
        for row in 0..<resolution {
            for column in 0..<resolution {
                points.append(
                    CGPoint(
                        x: bounds.minX + bounds.width * (CGFloat(column) + 0.5) / CGFloat(resolution),
                        y: bounds.minY + bounds.height * (CGFloat(row) + 0.5) / CGFloat(resolution)
                    )
                )
            }
        }
        // `point(inside:with:)` is a half-open test, so the exact edges are worth their own probes.
        points += [
            CGPoint(x: bounds.minX, y: bounds.minY),
            CGPoint(x: bounds.maxX, y: bounds.maxY),
            CGPoint(x: bounds.midX, y: bounds.maxY),
            CGPoint(x: bounds.minX - 1, y: bounds.midY),
            CGPoint(x: bounds.midX, y: bounds.minY - 1),
            CGPoint(x: bounds.maxX + 1, y: bounds.maxY + 1),
        ]
        return points
    }
}

#endif
