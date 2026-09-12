// MAC-17 · Production quality · ⏱ 60 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC17PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
