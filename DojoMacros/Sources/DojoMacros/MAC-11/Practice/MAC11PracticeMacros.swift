// MAC-11 · Diagnostics with Fix-It · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC11PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
