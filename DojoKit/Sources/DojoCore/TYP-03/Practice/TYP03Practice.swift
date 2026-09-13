// TYP-03 · Phantom type `ID<Tag>` · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct ID<Tag>: Hashable, Codable { let rawValue: String }` — `Tag` is never used in the body.
// 2. `typealias UserID = ID<User>`, `typealias OrderID = ID<Order>`.
// 3. Write `func fetch(user: UserID)` and try passing an `OrderID` to it.
//
// Done when
// - [ ] Passing an `OrderID` instead of a `UserID` is a compile error
// - [ ] `Codable` is transparent: in JSON it's just a string, not an object
// - [ ] `ID<User>` can be created from a literal once you add `ExpressibleByStringLiteral`
//
// Pitfall
// `Hashable` won't be synthesized automatically if `Tag` isn't `Hashable`. You need a conditional conformance or an
// explicit `extension ID: Hashable`.
