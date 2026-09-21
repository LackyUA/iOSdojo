// HIT-07 · Pass-through `UIWindow` · ⏱ 30 min — reference solution
// Task: TASKS-6-hit-testing.md

#if canImport(UIKit)

import SwiftUI
import UIKit

/// Marks the rectangle it occupies as a region the overlay window answers touches for.
///
/// A marker type rather than a frame: the toast's layout is SwiftUI's business, and anything the window computed
/// about it would be a copy that goes stale the moment the design changes.
final class OverlayHitTestingView: UIView { }

/// The search behind `OverlayWindow.point(inside:with:)`, kept out of the window so it can be read — and tested — on
/// any hierarchy at all.
@MainActor
enum OverlayHitTesting {

    /// Whether `point`, in `view`'s own coordinates, lands on a region marked as interactive.
    static func containsInteractiveRegion(at point: CGPoint, in view: UIView, with event: UIEvent?) -> Bool {
        // The same rejection rules hit testing uses. A toast fading out has an alpha below the cut-off long before it
        // is removed, and it must not keep stealing touches while it does.
        guard !view.isHidden, view.isUserInteractionEnabled, view.alpha > 0.01 else {
            return false
        }
        if view is OverlayHitTestingView {
            return view.point(inside: point, with: event)
        }
        for subview in view.subviews {
            let converted = subview.convert(point, from: view)
            if containsInteractiveRegion(at: converted, in: subview, with: event) {
                return true
            }
        }
        return false
    }
}

/// A window above the app that hosts SwiftUI content and stays out of the way of everything below it.
final class OverlayWindow<Content: View>: UIWindow {

    /// How much of the window answers touches.
    enum TouchPolicy {

        /// Nothing does: confetti, badges, decorations the user can never hit.
        case decorative

        /// Only the regions marked with `overlayHitTestable()`; every other touch reaches the app below.
        case interactiveRegions
    }

    init(
        windowScene: UIWindowScene,
        policy: TouchPolicy = .interactiveRegions,
        @ViewBuilder content: () -> Content
    ) {
        self.policy = policy
        super.init(windowScene: windowScene)
        commonInit(content: content())
    }

    /// A window that belongs to no scene — for previews and tests, where there is no scene to attach to.
    init(frame: CGRect, policy: TouchPolicy = .interactiveRegions, @ViewBuilder content: () -> Content) {
        self.policy = policy
        super.init(frame: frame)
        commonInit(content: content())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Asked about every touch in the app, so it answers `false` as early as it can.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        switch policy {
        case .decorative:
            false
        case .interactiveRegions:
            OverlayHitTesting.containsInteractiveRegion(at: point, in: self, with: event)
        }
    }

    // MARK: - Private Properties

    private let policy: TouchPolicy

    // MARK: - Private Methods

    private func commonInit(content: Content) {
        let controller = UIHostingController(rootView: content)
        // Without this the hosting controller paints an opaque background across the whole screen.
        controller.view.backgroundColor = .clear
        rootViewController = controller
        windowLevel = .alert
        // `isHidden = false`, never `makeKeyAndVisible()`: a key overlay window takes the first responder away from
        // the app, and the keyboard closes every time a toast appears.
        isHidden = false
    }
}

/// Owns the overlay window for as long as the scene lives.
///
/// A window created inside a function and stored nowhere is gone the moment that function returns, taking the overlay
/// with it — the "my toast shows for a frame and disappears" bug. Ownership belongs in something scene-shaped.
@MainActor
final class OverlayPresenter<Content: View> {

    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }

    func show(policy: OverlayWindow<Content>.TouchPolicy = .interactiveRegions, @ViewBuilder content: () -> Content) {
        window = OverlayWindow(windowScene: windowScene, policy: policy, content: content)
    }

    func hide() {
        // Hiding stops the window taking part in touch delivery at all; releasing it removes it from the scene.
        window?.isHidden = true
        window = nil
    }

    // MARK: - Private Properties

    private let windowScene: UIWindowScene
    private var window: OverlayWindow<Content>?
}

extension View {

    /// Makes this view's rectangle touchable inside an `OverlayWindow`.
    ///
    /// The marker is laid out by SwiftUI as a background of the content, so the interactive region follows the real
    /// layout: move the toast, change its size, animate it — the window needs no idea that anything happened.
    func overlayHitTestable() -> some View {
        background(OverlayHitTestingRegion())
    }
}

/// The `UIViewRepresentable` that plants an `OverlayHitTestingView` behind SwiftUI content.
struct OverlayHitTestingRegion: UIViewRepresentable {

    func makeUIView(context: Context) -> OverlayHitTestingView {
        OverlayHitTestingView()
    }

    func updateUIView(_ view: OverlayHitTestingView, context: Context) { }
}

// MARK: - Checks

/// The window answers only for marked regions, and a decorative one answers for nothing.
///
/// The checks use plain UIKit views: a `UIHostingController` needs a real screen before it lays anything out, and the
/// window has no opinion about where its markers come from.
@MainActor
enum HIT07Checks {

    static func run() {
        assertSearchFindsMarkedRegions()
        assertSearchRespectsTheRejectionRules()
        assertWindowPolicies()
        print("HIT-07 ✅ the toast's region answers, every other point in the window falls through to the app")
    }

    private static func assertSearchFindsMarkedRegions() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
        let container = UIView(frame: host.bounds)
        let toast = OverlayHitTestingView(frame: CGRect(x: 20, y: 40, width: 260, height: 80))
        host.addSubview(container)
        container.addSubview(toast)

        precondition(contains(CGPoint(x: 150, y: 80), in: host))
        precondition(!contains(CGPoint(x: 150, y: 400), in: host))
        precondition(!contains(CGPoint(x: 10, y: 80), in: host))

        // A hierarchy with no marker at all is transparent to every touch — the safe default.
        let empty = UIView(frame: host.bounds)
        empty.addSubview(UIView(frame: host.bounds))
        precondition(!contains(CGPoint(x: 150, y: 80), in: empty))
    }

    private static func assertSearchRespectsTheRejectionRules() {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
        let fading = UIView(frame: host.bounds)
        let toast = OverlayHitTestingView(frame: CGRect(x: 20, y: 40, width: 260, height: 80))
        host.addSubview(fading)
        fading.addSubview(toast)
        let point = CGPoint(x: 150, y: 80)

        precondition(contains(point, in: host))

        // A toast on its way out stops claiming touches while it is still on screen.
        fading.alpha = 0
        precondition(!contains(point, in: host))
        fading.alpha = 1

        toast.isHidden = true
        precondition(!contains(point, in: host))
        toast.isHidden = false

        toast.isUserInteractionEnabled = false
        precondition(!contains(point, in: host))
        toast.isUserInteractionEnabled = true

        precondition(contains(point, in: host))
    }

    private static func assertWindowPolicies() {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        let interactive = OverlayWindow(frame: frame) { Color.clear }
        let toast = OverlayHitTestingView(frame: CGRect(x: 20, y: 40, width: 260, height: 80))
        interactive.addSubview(toast)

        precondition(interactive.point(inside: CGPoint(x: 150, y: 80), with: nil))
        precondition(!interactive.point(inside: CGPoint(x: 150, y: 400), with: nil))
        // `hitTest` follows `point(inside:)`, so a point outside every region belongs to nobody in this window and
        // UIKit moves on to the window below it.
        precondition(interactive.hitTest(CGPoint(x: 150, y: 400), with: nil) == nil)
        precondition(interactive.hitTest(CGPoint(x: 150, y: 80), with: nil) === toast)

        let decorative = OverlayWindow(frame: frame, policy: .decorative) { Color.clear }
        decorative.addSubview(OverlayHitTestingView(frame: frame))
        precondition(!decorative.point(inside: CGPoint(x: 150, y: 80), with: nil))
        precondition(decorative.hitTest(CGPoint(x: 150, y: 80), with: nil) == nil)
    }

    private static func contains(_ point: CGPoint, in view: UIView) -> Bool {
        OverlayHitTesting.containsInteractiveRegion(at: point, in: view, with: nil)
    }
}

#endif
