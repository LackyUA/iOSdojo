// MAC-16 · Review your own macros · ⏱ 45 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC16PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
