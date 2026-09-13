// SEQ-09 · `Matrix` → `MutableCollection` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Make `subscript(position: Index)` with `get` and `set`.
// 2. Add `MutableCollection` conformance.
// 3. Check: `m.swapAt(0, 5)`, `m.sort()`, `m[2, 3] = x`, `m.reverse()`.
//
// Done when
// - [ ] `m.sort()` works (requires `Element: Comparable`)
// - [ ] `swapAt` doesn't copy the whole storage
// - [ ] Mutating via the 2D subscript and via the `Index` subscript gives the same result
// - [ ] `partition(by:)` and `shuffle()` are available
//
// Pitfall
// `MutableCollection` forbids changing `count` or the index structure — only values. If your `set` can change the size,
// the conformance is incorrect.
