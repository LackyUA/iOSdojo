// SRV-02 · Typed query parameters · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `struct QueryItem { let name: String; let value: String }` + factories for `Int`, `Bool`, `Date`, and arrays.
// 2. `func url(path: String, query: [QueryItem]) -> URL?` via `URLComponents`.
// 3. Check it with a parameter containing a space, a Cyrillic value, and an array `ids=1&ids=2`.
//
// Done when
// - [ ] The space and Cyrillic characters are escaped correctly
// - [ ] The code has no string concatenation with `?` and `&`
// - [ ] A `nil` parameter value doesn't end up in the URL as `key=nil`
//
// Pitfall
// `URLComponents.url` returns an optional and can yield `nil` for an invalid `path` (e.g. one without a leading slash).
// Handle this explicitly, not with `!`.
