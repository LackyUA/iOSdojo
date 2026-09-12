// MAC-13 · MemberAttribute macro · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC13PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
