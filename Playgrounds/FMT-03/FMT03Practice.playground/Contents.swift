// FMT-03 · `Money` type · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Money { let amount: Decimal; let currency: Currency }`, where `Currency` is an enum with
//    `rawValue: String`.
// 2. Add `func formatted() -> String` using `Decimal.formatted(.currency(code:))`.
// 3. Implement `+` so that adding different currencies is impossible (option: `throws`; option: a separate
//    `SameCurrencyPair` type).
//
// Done when
// - [ ] `Money(amount: 0.1, ...) + Money(amount: 0.2, ...)` gives exactly `0.3`
// - [ ] Trying to add UAH and USD either doesn't compile or throws an error
// - [ ] The type contains no `Double` or `Float`
//
// Pitfall
// `Decimal(0.1)` from a `Double` literal has already lost precision — use `Decimal(string:)` or integer literals.
