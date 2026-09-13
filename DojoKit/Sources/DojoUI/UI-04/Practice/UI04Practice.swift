// UI-04 · List screen with every state · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. States: `loading` (skeleton or spinner), `empty` (illustration + CTA), `failed` (text + Retry), `content`.
// 2. `loadingMore` at the bottom of the list — separate from the initial `loading`.
// 3. Pull-to-refresh that does not show a full-screen spinner.
//
// Done when
// - [ ] All 5 states render in 5 separate previews
// - [ ] `empty` differs from `failed` in both appearance and CTA
// - [ ] Retry after an error doesn't reset scroll or flash an empty screen
// - [ ] Refresh with existing content doesn't hide the content
// - [ ] The `switch` over state in `body` is exhaustive without `default`
//
// Pitfall
// "Empty" and "error" are different states with different actions. One shared "Something went wrong" screen for both is
// a product bug that only shows up in the design.
