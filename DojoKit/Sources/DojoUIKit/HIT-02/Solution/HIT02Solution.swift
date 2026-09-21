// HIT-02 · The four rejection rules · ⏱ 5 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import UIKit

/// `root` → `card` → `button`, with the card as the view the rules are applied to.
///
/// Every rule below is set on the *card*, and every probe asks for the *button* inside it. That is the point of the
/// kata: each of the four conditions stops the search at the card, so the interactive child behind it disappears too.
@MainActor
struct RejectionHierarchy {

    let root: UIView
    let card: UIView
    let button: UIView

    /// A point over the button, in `root` coordinates.
    static let insideButton = CGPoint(x: 120, y: 140)

    /// A point over the part of the button that hangs outside the card once `button` is moved down.
    static let insideOverhang = CGPoint(x: 120, y: 270)

    /// A point over the part of the moved button that is still inside the card.
    static let insideOverhangingButton = CGPoint(x: 120, y: 240)

    init() {
        root = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        card = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        button = UIView(frame: CGRect(x: 50, y: 78, width: 100, height: 44))
        // The card draws its overflowing child, so "visible" and "touchable" can come apart.
        card.clipsToBounds = false
        root.addSubview(card)
        card.addSubview(button)
    }

    func hitTest(_ point: CGPoint) -> UIView? {
        root.hitTest(point, with: nil)
    }
}

// MARK: - Checks

/// The four rules, one assertion each, plus the alpha cut-off measured rather than quoted.
@MainActor
enum HIT02Checks {

    static func run() {
        let views = RejectionHierarchy()
        let point = RejectionHierarchy.insideButton

        // Baseline: the button answers.
        precondition(views.hitTest(point) === views.button)

        // 1. Hidden. The card is skipped entirely, so the root — which also contains the point — answers instead.
        views.card.isHidden = true
        precondition(views.hitTest(point) === views.root)
        views.card.isHidden = false

        // 2. Transparent. `alpha` is the view's own opacity; what it draws is irrelevant.
        views.card.alpha = 0
        precondition(views.hitTest(point) === views.root)
        views.card.alpha = 1

        // 3. Interaction disabled. Note that the *button* stays enabled and is still unreachable: the search never
        // descends into a view that refuses interaction.
        views.card.isUserInteractionEnabled = false
        precondition(views.button.isUserInteractionEnabled)
        precondition(views.hitTest(point) === views.root)
        views.card.isUserInteractionEnabled = true

        // 4. Outside the bounds. `clipsToBounds = false` means the overhanging half is drawn, and `point(inside:)` on
        // the card answers `false` for it anyway — visible, and not touchable.
        views.button.frame = CGRect(x: 50, y: 178, width: 100, height: 100)
        precondition(views.hitTest(RejectionHierarchy.insideOverhang) === views.root)
        // The half that is still inside the card works, which is what makes the other half so confusing to report.
        precondition(views.hitTest(RejectionHierarchy.insideOverhangingButton) === views.button)

        assertAlphaCutOff()
        print("HIT-02 ✅ all four rules stop the search at the view they apply to, taking its children with it")
    }

    /// The `alpha` cut-off, found by probing instead of by quoting the documentation.
    ///
    /// The documentation says a view with an alpha below 0.01 is ignored, which leaves the boundary itself open —
    /// on the iOS 26 simulator the probe answers 0.011, so 0.01 exactly is already too transparent to touch. A measured
    /// number is also proof that a nearly-invisible view is still fully touchable: the other half of the
    /// "invisible but tappable" bug.
    private static func assertAlphaCutOff() {
        let views = RejectionHierarchy()
        let measured = lowestHitTestableAlpha(of: views.card, reaching: views.button, in: views)

        precondition(measured > 0, "a fully transparent view never takes part in hit testing")
        precondition(measured <= 0.02, "the cut-off sits at the documented 0.01, not at some larger value")
        print("HIT-02 · measured alpha cut-off: \(measured) — at and above it the card is still hit-tested")

        // Just above the cut-off the card is invisible to the eye and completely normal to a touch.
        views.card.alpha = measured
        precondition(views.hitTest(RejectionHierarchy.insideButton) === views.button)
    }

    /// The lowest alpha at which `view` still lets `target` be reached.
    private static func lowestHitTestableAlpha(
        of view: UIView,
        reaching target: UIView,
        in views: RejectionHierarchy
    ) -> CGFloat {
        let candidates: [CGFloat] = [0, 0.001, 0.005, 0.009, 0.01, 0.011, 0.02, 0.05, 0.1]
        let original = view.alpha
        defer { view.alpha = original }
        for alpha in candidates {
            view.alpha = alpha
            if views.hitTest(RejectionHierarchy.insideButton) === target {
                return alpha
            }
        }
        return .infinity
    }
}

#endif
