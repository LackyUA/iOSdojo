// MAC-10 · `@SnakeCaseCodable` · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC10PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
