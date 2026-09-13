// MOD-05 · Domain → UI model · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Take an `Order` with `MOD-04`-style fields (dates, `Money`, a status enum).
// 2. Create `struct OrderRow: Equatable, Identifiable` with display-ready strings: `title`, `subtitle`, `priceText`,
//    `statusColorName`.
// 3. Write `func map(_ order: Order, locale: Locale) -> OrderRow` and a test that two calls with the same input are
//    `==`.
//
// Done when
// - [ ] `OrderRow` contains no `Date`, no `Decimal`, and no domain enums
// - [ ] `OrderRow` conforms to `Equatable` without a custom implementation
// - [ ] The mapper idempotency test is green
//
// Pitfall
// If an `order: Order` field sneaks into `OrderRow` "just in case", the point of the separation is lost.
