// MAC-02 · Expand `@Test` · ⏱ 5 min — practice
// Task: TASKS-5-macros.md
//
// Task
// 1. Expand `@Test func example() { }` from Swift Testing.
// 2. Find the generated struct/variable that registers the test.
// 3. Answer in a comment: how does the framework discover tests without Objective-C reflection?
//
// Done when
// - [ ] The generated `enum`/`struct` with the test metadata is found
// - [ ] You can name the registration mechanism (a section in the binary / a static property)
// - [ ] Written down: a macro sees only syntax — it doesn't know whether the type you reference exists
//
// Pitfall
// This is the main limitation of macros, and the reason `@Mockable` (`MAC-14`) can't generate a mock for a protocol
// from another module.
