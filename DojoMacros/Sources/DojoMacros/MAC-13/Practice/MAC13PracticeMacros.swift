// MAC-13 · MemberAttribute macro · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(memberAttribute) macro ObservableProperties()`, which attaches your own attribute to all stored
//    properties of a type.
// 2. A second macro — an accessor macro that handles that attribute.
// 3. Apply both together and check the expansion order.
//
// Done when
// - [ ] The attribute appears on every stored property and on no computed one
// - [ ] The accessor macro ran after the memberAttribute macro — proven by the result
// - [ ] `static` and `lazy` properties are skipped
// - [ ] An expansion test covers both levels
//
// Pitfall
// Macro expansion order is partially unspecified. If your logic depends on another macro having already run, it's
// fragile. This kata is exactly about seeing that boundary.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC13PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
