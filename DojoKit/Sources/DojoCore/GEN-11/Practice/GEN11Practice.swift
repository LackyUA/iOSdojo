// GEN-11 · `@resultBuilder` for validation · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `@resultBuilder struct ValidationBuilder` with `buildBlock`, `buildOptional`, `buildEither`.
// 2. API: `let rules = Validate { NotEmpty(); MinLength(8); Contains(.digit) }`.
// 3. Add a condition inside the builder: `if requiresSymbol { Contains(.symbol) }`.
//
// Done when
// - [ ] A block with three rules compiles and runs
// - [ ] `if` inside the block works (that's `buildOptional`)
// - [ ] `if/else` with different rules works (that's `buildEither`)
//
// Pitfall
// Without `buildOptional`, a bare `if` in the builder produces a vague compile error. Add the methods one at a time and
// see which syntax each one "unlocks".
