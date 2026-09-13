// UI-03 · `@MainActor` and heavy work · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `@MainActor @Observable final class ReportViewModel` with a method that processes 100,000 records.
// 2. First do the work directly in the method and measure the UI freeze (the spinner will stop).
// 3. Move the computation into a `nonisolated` function or a separate actor, and return the result to main.
//
// Done when
// - [ ] The first version proves the freeze — the animation stops
// - [ ] Second version: the animation doesn't stop
// - [ ] Assigning the result to the VM property happens on main (the compiler guarantees it)
// - [ ] Zero `Sendable` warnings
//
// Pitfall
// `Task { }` inside a `@MainActor` class inherits the main actor — the work does **not** go to the background. You need
// `Task.detached` or a `nonisolated` function.
