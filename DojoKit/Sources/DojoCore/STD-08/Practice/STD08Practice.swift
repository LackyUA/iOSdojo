// STD-08 · Conditional `Collection` extension · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `extension Collection where Element: Numeric` with `var sum: Element`.
// 2. Try adding `var average` — and hit the fact that `Numeric` can't divide.
// 3. Write two extensions: `where Element: BinaryInteger` (returns `Double`) and `where Element: FloatingPoint`.
//
// Done when
// - [ ] `[1, 2, 3].average` and `[1.5, 2.5].average` both work
// - [ ] `["a", "b"].average` doesn't compile
// - [ ] The method is available on `Array`, `Set`, and `ArraySlice` without extra code
//
// Pitfall
// Empty collection: `average` must either return an optional or have a documented contract. Don't silently return `0`.
