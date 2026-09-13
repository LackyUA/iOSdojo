// MOD-01 · Four optionals → enum · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Write out the "bad" type:
//    `struct ScreenState { var isLoading: Bool; var items: [Item]?; var error: Error?; var isEmpty: Bool }`.
// 2. List in a comment 3 impossible combinations it allows (e.g. `isLoading == true` + `error != nil`).
// 3. Replace it with `enum ScreenState { case idle, loading, loaded([Item]), empty, failed(Error) }`.
//
// Done when
// - [ ] None of the three listed impossible combinations can be expressed in the new type
// - [ ] A `switch` over the state compiles without `default`
// - [ ] `loaded([])` and `empty` are deliberately either merged or kept separate, with the reasoning in a comment
//
// Pitfall
// If `case loaded([Item], isLoading: Bool)` shows up after the refactor, you're back to the original problem.
