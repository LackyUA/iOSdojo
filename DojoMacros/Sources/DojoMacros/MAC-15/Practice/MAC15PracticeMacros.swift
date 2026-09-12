// MAC-15 · Generics in the declaration · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC15PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
