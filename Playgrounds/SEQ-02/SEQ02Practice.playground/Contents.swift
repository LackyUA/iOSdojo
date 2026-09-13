// SEQ-02 · A page iterator · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct PagedSequence<Element>: Sequence` with fields `elements: [Element]`, `pageSize: Int`.
// 2. `struct PagedIterator<Element>: IteratorProtocol` with `Element == [Element]` — i.e. it yields arrays.
// 3. Test with 10 elements and `pageSize = 3`: there must be 4 pages, the last one with a single element.
//
// Done when
// - [ ] `for page in PagedSequence(...)` yields 4 arrays
// - [ ] A zero or negative `pageSize` is handled explicitly (a crash or a precondition — but deliberately)
// - [ ] A second pass over the same sequence gives the same result
//
// Pitfall
// `Sequence` doesn't promise repeatable iteration — but your implementation must pick a behavior and document it. If
// the iterator mutates the storage, the second pass yields nothing.
