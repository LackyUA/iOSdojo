// SEQ-18 · `Zip3Sequence` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Zip3Sequence<A: Sequence, B: Sequence, C: Sequence>: Sequence` with
//    `Element == (A.Element, B.Element, C.Element)`.
// 2. The iterator holds three iterators and finishes when the shortest one runs out.
// 3. A free function `func zip<A, B, C>(_ a: A, _ b: B, _ c: C) -> Zip3Sequence<A, B, C>`.
//
// Done when
// - [ ] `zip([1,2,3], "abc", [true, false])` yields 2 elements
// - [ ] The type works with the infinite sequence from `SEQ-01` as one of the arguments
// - [ ] `underestimatedCount` is implemented as the minimum of the three
//
// Pitfall
// If the first iterator is exhausted, don't pull the others — otherwise an infinite sequence or a sequence with side
// effects will behave unexpectedly.
