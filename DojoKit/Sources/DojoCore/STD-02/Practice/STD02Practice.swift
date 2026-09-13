// STD-02 · `Comparable` via a single operator · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Employee { let department: String; let lastName: String; let hireDate: Date }`.
// 2. Implement only `static func < (lhs:rhs:)`, sorting by the three fields in order.
// 3. Use tuple comparison: `(a.department, a.lastName) < (b.department, b.lastName)`.
//
// Done when
// - [ ] `>`, `<=`, `>=`, `sorted()`, `min()`, `max()` work without extra code
// - [ ] Sorting is stable across the three fields — check it on 6 elements with collisions
// - [ ] The file contains exactly one comparison operator
//
// Pitfall
// Tuple comparison works for up to 6 elements and requires all types to be `Comparable`. `Date` is; a custom enum isn't
// until you add it.
