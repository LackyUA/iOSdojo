// SEQ-10 · `CircularBuffer` + `RangeReplaceableCollection` · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Take `SEQ-06` and add an (empty) `init()` — the protocol requires it.
// 2. Implement `replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C)`.
// 3. `RangeReplaceableCollection` conformance.
//
// Done when
// - [ ] `append`, `insert(at:)`, `remove(at:)`, `removeSubrange`, `+=` work — all from a single method
// - [ ] `buffer.removeAll(where: { ... })` works
// - [ ] `init(repeating:count:)` is available
// - [ ] A test covers 5 `replaceSubrange` cases: insert at the start, middle, end, removal, replacement with a longer
//       array
//
// Pitfall
// This is the hardest conformance in the section. `replaceSubrange` must correctly handle `newElements` being longer
// than `subrange` — i.e. the buffer growing. Start with a simple implementation via an intermediate array, then
// optimize.
