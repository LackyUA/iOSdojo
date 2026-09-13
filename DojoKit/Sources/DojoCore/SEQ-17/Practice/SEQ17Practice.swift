// SEQ-17 · `LazyChunkedSequence` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct LazyChunkedSequence<Base: Sequence>: LazySequenceProtocol` with `Element == [Base.Element]`.
// 2. `extension LazySequenceProtocol { func chunks(of size: Int) -> LazyChunkedSequence<Elements> }`.
// 3. Check it in a chain: `array.lazy.filter { ... }.chunks(of: 3).map { ... }.first`.
//
// Done when
// - [ ] The whole chain is lazy: logs prove `filter` was called only for the first few elements
// - [ ] Without `.lazy` the method is unavailable
// - [ ] `chunks(of: 3)` on 10 elements yields 4 chunks, the last one with 1
//
// Pitfall
// `LazySequenceProtocol` requires `var elements: Elements`. If you return a plain `Sequence`, the chain "collapses"
// into an eager one at your step — and the rest of the optimization is lost.
