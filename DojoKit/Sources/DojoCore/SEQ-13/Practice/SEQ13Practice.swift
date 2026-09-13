// SEQ-13 · `OrderedSet` · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct OrderedSet<Element: Hashable>` with an `[Element]` + `Set<Element>` inside.
// 2. `RandomAccessCollection` conformance (insertion order).
// 3. `SetAlgebra` conformance: `union`, `intersection`, `symmetricDifference`, `insert`, `remove`, `contains`.
//
// Done when
// - [ ] `contains` is O(1), not O(n)
// - [ ] `Array(orderedSet)` preserves insertion order
// - [ ] `union` of two sets yields a deterministic order, and the rule is documented
// - [ ] The two protocols don't conflict: `count`, `isEmpty`, `first` are unambiguous
//
// Pitfall
// `SetAlgebra` and `Collection` both require `insert`/`remove`-like operations with different signatures, and
// `SetAlgebra.init()` conflicts with `RangeReplaceableCollection.init()`. Resolve the conflicts explicitly, not via
// `@_disfavoredOverload`.
