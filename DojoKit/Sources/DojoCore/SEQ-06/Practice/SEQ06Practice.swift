// SEQ-06 · `Queue` on a ring buffer + `Collection` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Queue<Element>` with fixed-size `[Element?]` storage, `head`, `tail`, `count`.
// 2. `enqueue`/`dequeue` in O(1) with index wrap-around.
// 3. `Collection` conformance: `startIndex`, `endIndex`, `index(after:)`, `subscript(position:)`.
//
// Done when
// - [ ] `startIndex` is always `0`, not `head` — and you can explain why that's more correct
// - [ ] `Array(queue)` yields elements in queue order, even when the buffer has "wrapped"
// - [ ] `queue.first`, `queue.count`, `queue.map` work without your own implementations
// - [ ] Test: fill it, dequeue half, enqueue more — the order is correct
//
// Pitfall
// The main mistake is making `Index == head`. Then `endIndex < startIndex` after wrap-around, and the whole stdlib
// breaks. A `Collection` index is a logical position from the start, not a physical one in the buffer.
