// TYP-02 · `@Clamped` · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `@propertyWrapper struct Clamped<Value: Comparable>` with `init(wrappedValue:_ range: ClosedRange<Value>)`.
// 2. `set` clamps the value to the range bounds.
// 3. Apply it as `@Clamped(0...100) var volume: Int = 150`.
//
// Done when
// - [ ] `volume` equals `100` after initialization, not `150`
// - [ ] Assigning `-10` gives `0`
// - [ ] The wrapper works with both `Double` and `Int` without changes
//
// Pitfall
// Clamping must be applied in `init` too, not only in `set` — otherwise the initial value slips through invalid.
