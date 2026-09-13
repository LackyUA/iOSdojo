// SEQ-11 · `LinkedList` with a custom `Index` · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `final class Node<Element>` and `struct LinkedList<Element>` with `head`/`tail`.
// 2. `struct Index: Comparable` holding a reference to a node — not an `Int`.
// 3. `Collection` conformance: `startIndex`, `endIndex`, `index(after:)`, `subscript`.
//
// Done when
// - [ ] `Index` compares correctly (`<` works), even though it isn't a number
// - [ ] `endIndex` represents the "past the last" position, with or without a sentinel node — but deliberately
// - [ ] `list.firstIndex(of: x)` and `list[index]` work
// - [ ] `list.count` is O(n), and that's documented
//
// Pitfall
// Implementing `Comparable` for an `Index` without an `Int` position is hard. The simplest honest option is to keep
// both the node and its ordinal position in `Index`. Compare by position, access by node.
