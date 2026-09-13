// SEQ-16 · `PriorityQueue` — and why not `Collection` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct PriorityQueue<Element: Comparable>` on a binary heap in an array.
// 2. `enqueue`, `dequeue`, `peek`, `count`.
// 3. Write a doc comment justifying why the type does not conform to `Collection`.
//
// Done when
// - [ ] `dequeue` always returns the minimum (or maximum) — tested with 20 random inserts
// - [ ] There is no `Collection` conformance
// - [ ] The justification is specific: the storage order isn't the logical order; `Collection` promises a stable
//       traversal, and a heap doesn't have one
// - [ ] Instead of `Collection` there's `func drain() -> some Sequence<Element>` that yields elements by priority
//
// Pitfall
// This is the most important kata in the section. A formal conformance is easy: just expose `storage` as is. But then
// `for in` yields heap order rather than priority order — a silent design-level bug.
