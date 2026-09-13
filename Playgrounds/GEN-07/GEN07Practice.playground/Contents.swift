// GEN-07 · The cost of an existential · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `protocol Shape { var area: Double { get } }` and three conforming structs.
// 2. Write `func totalArea<T: Shape>(_ shapes: [T]) -> Double` and `func totalArea(_ shapes: [any Shape]) -> Double`.
// 3. Run both on 100,000 elements and compare the timings.
//
// Done when
// - [ ] Both functions return the same result
// - [ ] The measured time difference is recorded in a comment
// - [ ] You can explain why the generic version doesn't accept an array of different shapes
//
// Pitfall
// Measure in the Release configuration. In Debug the difference is drowned out by the lack of optimizations.
