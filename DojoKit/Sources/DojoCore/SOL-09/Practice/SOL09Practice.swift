// SOL-09 · Legacy under tests · ⏱ 60 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take a "bad" 150+ line file (your own old code, or generate a deliberately bad one).
// 2. First cover the behavior with tests — without changing a single line. At least 6 tests.
// 3. Only then refactor: in small steps, with green tests after each one.
// 4. Record how many times the tests saved you from a regression.
//
// Done when
// - [ ] 6+ tests written before the first code change
// - [ ] Tests are green before, during and after the refactoring
// - [ ] No test was rewritten "to fit the new code" (otherwise it wasn't protecting behavior)
// - [ ] The number is recorded: how many times a test failed during refactoring
//
// Pitfall
// If the code can't be covered by tests without changing it, there's a recipe: a minimal "seam" — extract a method,
// turn a dependency into a parameter with a default. It's the safest kind of change, and you can make it before writing
// tests.
