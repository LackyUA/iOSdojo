// MAC-03 · `#warning` and `#error` · ⏱ 5 min — practice
// Task: TASKS-5-macros.md
//
// Task
// 1. Add `#warning("TODO: replace with typed throws")` to your code.
// 2. Add `#error` to an `#if` branch that must not compile (e.g. an unsupported platform).
// 3. Confirm that the warning shows up in Xcode's issue list and that `#error` blocks the build.
//
// Done when
// - [ ] The warning with your text is visible in the Issue Navigator
// - [ ] `#error` in an inactive `#if` branch does not break the build
// - [ ] `#error` in an active branch breaks the build
//
// Pitfall
// These are built-in macros, not preprocessor directives. They run during macro expansion, so they work with string
// literals but not with computed strings.
