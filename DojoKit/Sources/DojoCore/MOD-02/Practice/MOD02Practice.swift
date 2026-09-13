// MOD-02 · Two initializers · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Profile { let id: UUID; let name: String; let age: Int }` — keep the memberwise init.
// 2. Add `init?(json: [String: Any])` that checks types and key presence.
// 3. Check three inputs: valid JSON, JSON without `name`, and JSON where `age` is a `String`.
//
// Done when
// - [ ] The memberwise init is still available (the type is still convenient for tests)
// - [ ] The three checks yield `Profile`, `nil`, `nil`
// - [ ] The memberwise init has no validation at all — it lives only in the failable one
//
// Pitfall
// If `init?` lives in the same file as the domain, that's fine for a kata, but note in a comment which layer it would
// move to in a real project.
