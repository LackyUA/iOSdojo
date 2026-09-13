// SEQ-03 · `Stack<T>: Sequence` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Stack<Element>` with `push`, `pop`, `peek`, `isEmpty`, backed by an array.
// 2. Add `Sequence` conformance, iterating from the top to the bottom.
// 3. Check that `map`, `contains`, `reduce`, `first` came for free.
//
// Done when
// - [ ] `Array(stack)` yields elements starting from the last one pushed
// - [ ] `stack.contains(x)` works without your own implementation
// - [ ] Iteration does not destroy the stack — after `for in` all elements are still there
//
// Pitfall
// The simplest path is `makeIterator() { storage.reversed().makeIterator() }`. But make sure `reversed()` on `Array` is
// a `ReversedCollection` with no copying, not a new array.
