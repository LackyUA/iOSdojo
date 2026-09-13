// MAC-15 · Generics in the declaration · ⏱ 30 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. Apply `MAC-07` (`@AddInit`) to `struct Box<T: Equatable> { let value: T }`.
// 2. Record what was generated — and whether it was generated correctly.
// 3. Dig into `declaration.as(StructDeclSyntax.self)?.genericParameterClause` and `genericWhereClause`.
//
// Done when
// - [ ] The init for the generic type is correct
// - [ ] The type's `where` clause is taken into account or explicitly ignored (with a comment)
// - [ ] You can explain why the macro doesn't know whether `T` is actually `Equatable` at a particular use site
// - [ ] At least 3 things the macro can't see are written down: types from other modules, the result of type inference,
//       conformances
//
// Pitfall
// A macro runs before type checking. To a macro, `let x = 5` isn't an `Int` but an `IntegerLiteralExprSyntax`. All the
// logic has to be built on syntax, and that fundamentally limits what can be generated at all.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC15PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
