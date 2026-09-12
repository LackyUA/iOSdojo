// MAC-08 · `@UserDefault` · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC08PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
