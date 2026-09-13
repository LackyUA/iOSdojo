// MAC-08 · `@UserDefault` · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(accessor) macro UserDefault(_ key: String)`.
// 2. It turns `@UserDefault("theme") var theme: String = "light"` into a computed property with `get`/`set` over
//    `UserDefaults`.
// 3. Compare the result with the property wrapper from `TYP-06`.
//
// Done when
// - [ ] Reading and writing work, and the value survives a "relaunch" (a new `UserDefaults` suite)
// - [ ] The default value is used when the key is missing
// - [ ] In a comment — a comparison with `TYP-06` on 4 criteria: in-memory type, access to `projectedValue`, compile
//       time, error clarity
// - [ ] The conclusion is written down explicitly: which one to pick in a real project
//
// Pitfall
// An accessor macro turns a stored property into a computed one — which means the default value `= "light"` is no
// longer an initial value; you have to **extract it from the syntax** and insert it into `get`.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC08PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
