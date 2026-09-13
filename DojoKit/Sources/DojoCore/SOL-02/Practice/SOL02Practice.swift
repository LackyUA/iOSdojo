// SOL-02 · Type check → polymorphism · ⏱ 15 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Write "bad" code: `func area(of shape: Any) -> Double` with three `if let x = shape as? Circle`.
// 2. Replace it with `protocol Shape { var area: Double { get } }`.
// 3. Add a fourth shape — and make sure no existing file changed.
//
// Done when
// - [ ] Zero `as?` in the final code
// - [ ] Adding `Triangle` is one new file, 0 changed
// - [ ] The `switch` on type hasn't moved somewhere else in disguise
//
// Pitfall
// Sometimes `as?` is right: when types come from someone else's framework and you can't add a conformance. Tell "don't
// want to" apart from "can't".
