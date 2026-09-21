// HIT-06 · Pass-through overlay view · ⏱ 15 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// A full-screen overlay that is touchable only where its own subviews are.
///
/// The check is on the *result*, not on the point: `super.hitTest` still has to run, because it is what finds the
/// banner. Returning `nil` before calling it would disable the subviews along with the background.
final class PassthroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit === self ? nil : hit
    }
}

/// A coach-mark layout: a screen with a button, an overlay covering all of it, and a banner inside the overlay.
@MainActor
struct OverlayLayout {

    let root = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
    let backgroundButton = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
    let overlay: UIView
    let banner = UIView(frame: CGRect(x: 20, y: 40, width: 260, height: 80))

    /// A point over the banner, in `root` coordinates.
    static let onBanner = CGPoint(x: 150, y: 80)

    /// A point over the overlay's empty space, in `root` coordinates.
    static let besideBanner = CGPoint(x: 150, y: 400)

    init(overlay: UIView) {
        self.overlay = overlay
        overlay.frame = root.bounds
        root.addSubview(backgroundButton)
        root.addSubview(overlay)
        overlay.addSubview(banner)
    }

    func hitTest(_ point: CGPoint) -> UIView? {
        root.hitTest(point, with: nil)
    }
}

// MARK: - Checks

/// The overlay against the two things people reach for first, both of which fail in a different direction.
@MainActor
enum HIT06Checks {

    static func run() {
        let passthrough = OverlayLayout(overlay: PassthroughView())
        precondition(passthrough.hitTest(OverlayLayout.onBanner) === passthrough.banner)
        precondition(passthrough.hitTest(OverlayLayout.besideBanner) === passthrough.backgroundButton)
        // The overlay itself is never a hit-test result anywhere on screen.
        precondition(!everyPoint(of: passthrough.root).contains { passthrough.hitTest($0) === passthrough.overlay })

        assertPlainOverlaySwallowsEverything()
        assertDisabledOverlayDisablesItsSubviews()
        print("HIT-06 ✅ the banner answers, the empty space falls through, the overlay never answers for itself")
    }

    /// A transparent overlay is still a view: it contains every point and claims every touch.
    private static func assertPlainOverlaySwallowsEverything() {
        let layout = OverlayLayout(overlay: UIView())
        layout.overlay.backgroundColor = .clear

        precondition(layout.hitTest(OverlayLayout.onBanner) === layout.banner)
        precondition(layout.hitTest(OverlayLayout.besideBanner) === layout.overlay)
    }

    /// `isUserInteractionEnabled = false` is the opposite mistake: it stops the search at the overlay, so the banner
    /// inside it goes with it. The rule applies to the subtree, not to the one view.
    private static func assertDisabledOverlayDisablesItsSubviews() {
        let layout = OverlayLayout(overlay: UIView())
        layout.overlay.isUserInteractionEnabled = false

        precondition(layout.hitTest(OverlayLayout.besideBanner) === layout.backgroundButton)
        precondition(layout.hitTest(OverlayLayout.onBanner) === layout.backgroundButton)
        precondition(layout.banner.isUserInteractionEnabled)
    }

    private static func everyPoint(of view: UIView, step: CGFloat = 10) -> [CGPoint] {
        stride(from: view.bounds.minX, to: view.bounds.maxX, by: step).flatMap { x in
            stride(from: view.bounds.minY, to: view.bounds.maxY, by: step).map { y in
                CGPoint(x: x, y: y)
            }
        }
    }
}

#endif
