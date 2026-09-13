// SEQ-21 · CoW for your own struct · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Take `SEQ-06` or `SEQ-08` and move the storage into a `final class Storage`.
// 2. Add `private mutating func ensureUnique()` using `isKnownUniquelyReferenced`.
// 3. Add a static copy counter and write three tests.
//
// Done when
// - [ ] Passing the struct to a function — 0 copies
// - [ ] Reading from a copy — 0 copies
// - [ ] Writing to a copy — exactly 1 copy, the original is unchanged
// - [ ] `ensureUnique()` is called in every mutating method — verify that none is missed
//
// Pitfall
// A missed `ensureUnique()` call in one mutating method causes a bug that shows up only with a specific sequence of
// operations. A copy counter + a test for each mutating method is the only reliable approach.
