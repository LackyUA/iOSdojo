// UI-05 · Design system component · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `struct Card<Content: View>: View` with a `@ViewBuilder` init.
// 2. Three style variants via a dedicated type: `CardStyle` (`plain`, `elevated`, `outlined`) — not via `Bool`
//    parameters.
// 3. Bonus: a custom `CardStyle` protocol in the style of `ButtonStyle`, with a `.cardStyle(_:)` modifier.
//
// Done when
// - [ ] `Card { Text("hi") }` compiles without an explicit type
// - [ ] The three styles render side by side in one preview
// - [ ] Adding a fourth style doesn't change `Card`
// - [ ] The component has no hardcoded spacing — everything comes from tokens (`Spacing.m`)
// - [ ] Works in light and dark themes (checked in previews)
//
// Pitfall
// `init(isElevated: Bool, hasBorder: Bool, isCompact: Bool)` is 8 combinations, of which 3 are valid. A style as a type
// makes the other 5 unrepresentable.
