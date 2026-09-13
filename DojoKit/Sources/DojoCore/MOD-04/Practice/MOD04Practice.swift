// MOD-04 · Logic inside the model · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Subscription { let startDate: Date; let period: Period; let price: Money; let cancelledAt: Date? }`.
// 2. Add computed properties: `isActive`, `nextBillingDate`, `daysUntilRenewal`, `totalPaid`.
// 3. Take the time from a parameter, not from `Date()` — make methods like `isActive(at:)` or inject `DateProviding`
//    (see `SRV-01`).
//
// Done when
// - [ ] There is no `SubscriptionHelper` / `SubscriptionUtils` file
// - [ ] All properties are testable without mocking the system clock
// - [ ] `nextBillingDate` is correct for a monthly subscription that started on January 31
//
// Pitfall
// Adding a month to January 31 is a classic bug. Use `Calendar.date(byAdding:to:)`, not arithmetic in seconds.
