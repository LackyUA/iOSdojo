// MAC-14 · `@Mockable` · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC14PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
