// SEQ-04 · `CountedSet` + literal · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct CountedSet<Element: Hashable>` with `[Element: Int]` storage.
// 2. API: `insert`, `remove`, `count(of:)`, `subscript(element) -> Int`.
// 3. Add `Sequence` (yields each element as many times as it occurs) and `ExpressibleByArrayLiteral`.
//
// Done when
// - [ ] `let bag: CountedSet = ["a", "a", "b"]` compiles
// - [ ] `bag.count(of: "a") == 2`
// - [ ] `Array(bag).count == 3`, and the order is documented (it's nondeterministic!)
//
// Pitfall
// `Dictionary` iteration order is nondeterministic across runs. If a test compares the array directly, it will be
// flaky. Compare as a `CountedSet` or sort first.
