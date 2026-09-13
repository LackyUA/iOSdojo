// MAC-04 · `#stringify` + a third element · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. In the template `#stringify`, change the return type to `(T, String, Int)`, where the third element is the number
//    of tokens in the expression.
// 2. Implement the count by walking the syntax tree.
// 3. Check it on `#stringify(1 + 2 * 3)`.
//
// Done when
// - [ ] A three-element tuple is returned
// - [ ] The token count is correct and verified by a test
// - [ ] The declaration in `Dojo` (`@freestanding(expression)`) matches the implementation
//
// Pitfall
// The macro declaration and implementation live in different targets. Changing the return type in one without the other
// gives a vague "external macro implementation type could not be found" error.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC04PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
