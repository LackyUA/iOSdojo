// TYP-04 · `@dynamicMemberLookup` over a dictionary · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `@dynamicMemberLookup struct JSONBox` with a `storage: [String: Any]` field.
// 2. Implement `subscript<T>(dynamicMember key: String) -> T?` and a second variant that returns `JSONBox?` for nested
//    objects.
// 3. Test it on nested JSON: `box.user?.address?.city`.
//
// Done when
// - [ ] A three-level nested chain reads without `as?` and without `["key"]`
// - [ ] A wrong type yields `nil`, not a crash
// - [ ] A comment answers: why `Codable` is better than this in a production domain
//
// Pitfall
// Two overloaded `subscript(dynamicMember:)` with different return types often break type inference. You may need an
// explicit annotation at the call site.
