// MAC-11 · Diagnostics with Fix-It · ⏱ 30 min — practice, public declaration
// Task: TASKS-5-macros.md
//
// Task
// 1. Take `MAC-06` (`@CaseDetection`, which only works with enums).
// 2. When applied to a `struct`, emit a `Diagnostic` with `severity: .error` and a clear message.
// 3. Add a `FixItMessage` that offers to remove the attribute.
//
// Done when
// - [ ] `@CaseDetection struct Foo {}` produces an error with your text, not a plugin crash
// - [ ] The error points to the right line (the node `position` is taken from)
// - [ ] The Fix-It appears in Xcode and removes the attribute when applied
// - [ ] A test checks the diagnostic itself via `assertMacroExpansion(diagnostics:)`
//
// Pitfall
// Using `throw` in a macro produces a generic "macro expansion failed" error. For decent DX you need
// `context.diagnose(...)` and returning an empty array, not `throw`.
