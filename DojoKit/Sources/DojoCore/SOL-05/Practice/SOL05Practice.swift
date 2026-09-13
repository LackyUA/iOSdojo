// SOL-05 · Breaking up a God object · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Write (or take) an 80+ line `ProfileViewController`/`ProfileManager` that handles networking, caching, validation,
//    formatting and navigation.
// 2. List its responsibilities and name the reason to change for each.
// 3. Extract three types. The original stays as a coordinator.
//
// Done when
// - [ ] The three new types are tested independently
// - [ ] The coordinator contains no business logic — only the sequence of calls
// - [ ] None of the three types knows about the other two (only via protocols or via the coordinator)
// - [ ] The total line count has probably grown — and that's fine
//
// Pitfall
// Splitting into `ProfileHelper`, `ProfileUtils`, `ProfileManager2` is the same problem with new names. Each type
// should be named after its responsibility.
