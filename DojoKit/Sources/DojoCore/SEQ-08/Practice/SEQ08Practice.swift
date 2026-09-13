// SEQ-08 · `Matrix` + `RandomAccessCollection` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Matrix<Element>` with `rows`, `columns` and flat `[Element]` storage.
// 2. `subscript(row: Int, column: Int) -> Element` with bounds checking.
// 3. `RandomAccessCollection` conformance with `Index == Int`, iterating in row-major order.
//
// Done when
// - [ ] Two subscripts coexist: `m[1, 2]` and `m[5]` (by `Index`)
// - [ ] `m.count == rows * columns`
// - [ ] `m.distance(from:to:)` and `m.index(_:offsetBy:)` are O(1)
// - [ ] `m.dropFirst(1000)` on a 1000×1000 matrix is instant
//
// Pitfall
// `RandomAccessCollection` is a **complexity promise**, not a set of methods. If your `index(_:offsetBy:)` is O(n), you
// lied to the compiler and will get silent performance problems in stdlib algorithms.
