// GEN-02 · `firstDuplicate` · ⏱ 5 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `func firstDuplicate<T: Hashable>(in sequence: some Sequence<T>) -> T?`.
// 2. Implement it in a single pass using a `Set`.
// 3. Test it on `[Int]`, `[String]`, `Set<Int>` and your own `Hashable` type.
//
// Done when
// - [ ] One function works for all four inputs
// - [ ] Complexity is O(n), not O(n²)
// - [ ] An empty sequence and a sequence without duplicates both return `nil`
//
// Pitfall
// A `Set<Int>` can't contain duplicates — a good check that your function doesn't crash on "pointless" input.
