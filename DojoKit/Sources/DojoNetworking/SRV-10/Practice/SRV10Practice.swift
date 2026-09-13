// SRV-10 · Typed analytics · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1.
//    `enum AnalyticsEvent { case screenViewed(name: String), purchaseCompleted(orderID: OrderID, amount: Money), searchPerformed(query: String, resultsCount: Int) }`.
// 2. `var name: String` and `var parameters: [String: Any]` as computed properties on the enum.
// 3. `protocol AnalyticsService { func track(_ event: AnalyticsEvent) }` + an implementation and a spy mock.
//
// Done when
// - [ ] `track("purchase_complete", ["amount": 5])` (with a typo and a missing required field) is no longer possible
// - [ ] Adding an event is one case + two lines in a `switch`, and the compiler points to everywhere else that needs
//       updating
// - [ ] A spy in the test checks that the event was sent with the correct parameters
// - [ ] `parameters` contains no `nil` values
//
// Pitfall
// There's still a `[String: Any]` at the output — but now it's generated in one place and checked by one test, instead
// of being scattered across 40 screens.
