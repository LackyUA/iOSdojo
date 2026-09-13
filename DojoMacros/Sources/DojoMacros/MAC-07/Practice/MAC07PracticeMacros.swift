// MAC-07 · `@AddInit` · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(member, names: named(init)) macro AddInit()`.
// 2. For a class with stored properties, it generates a memberwise init.
// 3. Handle: `let` without a value (required parameter), `var` with a value (parameter with a default), computed
//    property (skip).
//
// Done when
// - [ ] A class with 4 properties gets a correct init
// - [ ] A property with a default value becomes a parameter with a default
// - [ ] Computed properties and `static` properties do not end up in the init
// - [ ] `lazy var` is handled explicitly (skipped or included — but deliberately)
//
// Pitfall
// What tells stored from computed is an `accessorBlock` with `get`. But `didSet`/`willSet` also live in
// `accessorBlock`, and such a property is stored. Check specifically for `get`/`set`.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC07PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
