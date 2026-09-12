// MAC-07 · `@AddInit` · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC07PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
