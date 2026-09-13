// MAC-05 · `#URL` with validation · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. `@freestanding(expression) macro URL(_ string: String) -> URL`.
// 2. The implementation checks that the argument is a string literal (not a variable) and that
//    `Foundation.URL(string:)` accepts it.
// 3. It generates `URL(string: "...")!` — which is now safe.
//
// Done when
// - [ ] `#URL("https://example.com")` compiles
// - [ ] `#URL("not a url")` produces a compile error, not a runtime crash
// - [ ] `#URL(someVariable)` produces an error explaining "a literal is required"
// - [ ] The generated code contains `!`, and a comment explains why it's acceptable here
//
// Pitfall
// The "is it a literal" check is `argument.as(StringLiteralExprSyntax.self)`. Don't forget interpolation: `"\(x)"` is
// also a `StringLiteralExprSyntax`, but with an expression segment.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC05PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
