// MAC-17 · Production quality · ⏱ 60 min — practice, public declaration
// Task: TASKS-5-macros.md
//
// Task
// 1. Pick one macro and bring it to library quality.
// 2. Diagnostics: every incorrect application produces a clear error with a Fix-It, and not a single plugin crash.
// 3. Access level: the generated code is correct for `public`, `internal`, and `private` types.
// 4. Doc comments with examples, a README with limitations.
// 5. Tests: expansion, diagnostics, edge cases (generics, nested types, `@available`).
//
// Done when
// - [ ] Zero plugin crashes across 10 deliberately incorrect applications
// - [ ] A `public struct` gets a `public init`, an `internal` one gets `internal`
// - [ ] The README honestly lists what the macro does not support
// - [ ] `swift test` passes, and coverage includes every diagnostic branch
// - [ ] The macro works in a nested type (`extension Foo { @AddInit struct Bar {} }`)
//
// Pitfall
// Access level is the most commonly missed detail. A `public struct` with an `internal init` can't be created from
// another module, and the error will show up in the user's code, not in the macro — so it will look like your bug in an
// obscure place.
