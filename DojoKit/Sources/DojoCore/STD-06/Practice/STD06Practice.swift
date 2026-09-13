// STD-06 · `ExpressibleByStringLiteral` for fixtures · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `struct Email` with validation and `init?(_ string: String)`.
// 2. Add `ExpressibleByStringLiteral` conformance, where the init calls `preconditionFailure` on an invalid literal.
// 3. Use it in a test: `let email: Email = "user@example.com"`.
//
// Done when
// - [ ] Tests contain no `Email("...")!`
// - [ ] An invalid literal crashes — and a comment explains why that's acceptable for literals specifically
// - [ ] Runtime data still goes through the failable init, not the literal one
//
// Pitfall
// A literal is known at compile time, so the crash is deterministic and surfaces on the first test run. Don't do this
// for network data — that's a completely different risk.
