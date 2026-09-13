// STA-01 · Pure pagination · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `struct PageRequest { let offset: Int; let limit: Int }` and `struct Page<T> { let items: [T]; let total: Int }`.
// 2. `func nextRequest(after page: Page<T>, current: PageRequest) -> PageRequest?` — a pure function.
// 3. Edge-case tests: first page, last page, `total == 0`, `total` smaller than `limit`, partial last page.
//
// Done when
// - [ ] The function has no access to the network or to state — only its parameters
// - [ ] All 5 edge cases are covered by tests
// - [ ] The last page yields `nil`, not a request with `offset > total`
// - [ ] The file has no UIKit/SwiftUI import
//
// Pitfall
// The most common bug is "the last page is full". If `total = 20` and `limit = 10`, the second page must be followed by
// `nil`, not a third request.
