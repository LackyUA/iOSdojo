// STD-07 · Stable `id` · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Make a model with `id = UUID()` as a default in the memberwise init.
// 2. Build a SwiftUI `List`, reload the data with the same array, and record that all rows re-rendered/"jumped".
// 3. Switch to an `id` that comes from the server, and repeat.
//
// Done when
// - [ ] The first version demonstrates the problem (proven by an animation or an `onAppear` log)
// - [ ] The second version has zero re-renders for identical data
// - [ ] A comment states the rule: `id` must be stable across loads, not across instances
//
// Pitfall
// `UUID()` as a property default is generated on **every** instantiation — a silent time bomb, because the code looks
// correct.
