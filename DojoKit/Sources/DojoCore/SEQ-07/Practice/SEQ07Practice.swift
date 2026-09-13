// SEQ-07 · `Deque` + `BidirectionalCollection` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Extend `SEQ-06` into a `Deque` with `prepend`/`removeLast`.
// 2. Add `BidirectionalCollection`: implement `index(before:)`.
// 3. Check what came for free.
//
// Done when
// - [ ] `deque.last` works in O(1), not via a full pass
// - [ ] `deque.reversed()` returns a `ReversedCollection`, not an array
// - [ ] `deque.suffix(3)`, `deque.dropLast()`, `deque.lastIndex(of:)` work
// - [ ] A comment lists at least 5 methods that this particular protocol added
//
// Pitfall
// Before `BidirectionalCollection`, `last` was O(n). Check this on `SEQ-06` to see the difference with your own eyes.
