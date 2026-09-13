// COD-04 · Enum with a fallback · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `enum OrderStatus: String, Decodable { case pending, shipped, delivered, unknown }`.
// 2. Implement `init(from decoder:)` so an unknown string yields `.unknown` instead of an error.
// 3. Test: JSON with the status `"returned"` decodes successfully.
//
// Done when
// - [ ] An unknown value doesn't break decoding of the whole object
// - [ ] `.unknown` keeps the original string (for logs/analytics)
// - [ ] A `switch` on the status in the UI handles `.unknown` explicitly
//
// Pitfall
// If `.unknown` doesn't keep the raw string, you won't find out that the backend added a new status. Make it
// `case unknown(String)`.
