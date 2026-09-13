// MAC-12 · Expansion tests · ⏱ 30 min — practice
// Task: TASKS-5-macros.md
//
// Task
// 1. For any of your macros, write 3 positive tests using `assertMacroExpansion`.
// 2. And 2 negative ones: wrong declaration kind, wrong argument — checking `diagnostics:`.
// 3. Add one test with a "tricky" input: a generic, `public`, a property with an attribute.
//
// Done when
// - [ ] All 5+ tests pass
// - [ ] The expected code in the test is formatted exactly as the macro generates it (indentation included)
// - [ ] Negative tests check the diagnostic text, not just its presence
// - [ ] Refactoring the macro implementation without changing its output doesn't break the tests
//
// Pitfall
// `assertMacroExpansion` compares strings including indentation. Most of the time will go into matching whitespace.
// Print the actual result to the console and copy it from there.
