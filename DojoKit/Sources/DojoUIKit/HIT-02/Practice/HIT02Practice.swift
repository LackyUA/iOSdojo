// HIT-02 · The four rejection rules · ⏱ 5 min — practice
// Task: TASKS-6-hit-testing.md
//
// Task
// 1. Take the hierarchy from `HIT-01`. Make the `card` fail, one at a time, each of the four conditions that stop hit
//    testing: `isHidden`, low `alpha`, `isUserInteractionEnabled == false`, and the point being outside `bounds`.
// 2. Assert what `root.hitTest(pointInsideTheButton, with: nil)` returns in each case.
// 3. Record which of the four also make the subviews unreachable.
//
// Steps
// 1. Four assertions, each restoring the view's state afterwards.
// 2. Find the alpha threshold empirically — try `0.0`, `0.005`, `0.01`, `0.02`. The documentation says a view with an
//    alpha below 0.01 is ignored; confirm the boundary instead of trusting the number, and write down what you
//    measured.
// 3. Set `isUserInteractionEnabled = false` on the card while the button inside it stays enabled. The button is
//    unreachable, because the search never descends into the card.
// 4. Move the button so it sticks out of the card (`card.clipsToBounds = false`, so it is still visible) and probe the
//    overhanging half.
// 5. In a comment: which of the four rules produce a view that is visible but untappable? That is the state that
//    generates bug reports.
//
// Done when
// - [ ] Four assertions, one per rule, each with the expected return value spelled out
// - [ ] The measured alpha threshold is written down, not guessed
// - [ ] A disabled or hidden parent is shown to hide its interactive children
// - [ ] A subview outside its parent's bounds is shown to be visible but never hit
//
// Pitfall
// It is the view's `alpha` that counts, not what it draws: `backgroundColor = .clear` is fully hit-testable. "Invisible
// but tappable" and "visible but untappable" look identical on screen and have opposite causes.
