// SEQ-01 · `Sequence` via `AnyIterator` · ⏱ 5 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `func fibonacci() -> some Sequence<Int>` built on `AnyIterator`.
// 2. The sequence is infinite — state lives in the closure.
// 3. Use `.prefix(10)` and `.first(where: { $0 > 1000 })`.
//
// Done when
// - [ ] `Array(fibonacci().prefix(10))` yields the correct 10 numbers
// - [ ] `for in` without `prefix` hangs — and you understand why that's expected
// - [ ] `.first(where:)` finishes without computing the whole sequence
//
// Pitfall
// `.map` on an infinite sequence hangs, because `Sequence.map` is eager. `.lazy.map` isn't.
