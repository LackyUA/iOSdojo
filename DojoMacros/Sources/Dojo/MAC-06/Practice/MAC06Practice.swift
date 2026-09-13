// MAC-06 · `@CaseDetection` · ⏱ 15 min — practice, public declaration
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(member, names: arbitrary) macro CaseDetection()`.
// 2. For `enum FeedState { case idle, loading, loaded([Item]) }` it generates `var isIdle: Bool`,
//    `var isLoading: Bool`, `var isLoaded: Bool`.
// 3. Handle cases with associated values via `if case .loaded = self`.
//
// Done when
// - [ ] All three properties are generated and work
// - [ ] A case with an associated value yields a correct `is`
// - [ ] Names are capitalized correctly (`idle` → `isIdle`, not `isidle`)
// - [ ] A single-line `case a, b, c` is handled (it's one `EnumCaseDeclSyntax` with three elements)
//
// Pitfall
// `case a, b, c` is the classic missed detail. Iterate over `caseDecl.elements`, not over `caseDecl`.
