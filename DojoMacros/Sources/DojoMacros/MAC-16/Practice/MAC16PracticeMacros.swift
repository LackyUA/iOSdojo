// MAC-16 · Review your own macros · ⏱ 45 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. Take three of your macros from the previous katas.
// 2. For each, write an alternative implementation (or sketch one) without a macro: a property wrapper, a generic, a
//    protocol extension, script-based code generation.
// 3. Rate them on 4 criteria: compile time, error clarity, debuggability, clarity for a new developer.
//
// Done when
// - [ ] Each of the three has an explicit verdict: macro justified / not justified
// - [ ] The compile-time impact is measured (at least roughly, `-Xfrontend -debug-time-function-bodies`)
// - [ ] At least one macro that wasn't worth building is named
// - [ ] Your own criterion for "when a macro is justified" is stated in 1–2 sentences
//
// Pitfall
// Macros add a dependency on `swift-syntax` — that's tens of seconds on a clean build, plus compatibility tied to the
// Xcode version. For saving 5 lines of boilerplate, that's a bad deal.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC16PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
