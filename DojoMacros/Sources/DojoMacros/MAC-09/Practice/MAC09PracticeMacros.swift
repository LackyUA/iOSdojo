// MAC-09 · Peer macro for an `async` version · ⏱ 15 min — practice, SwiftSyntax implementation
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(peer, names: overloaded) macro AddAsync()`.
// 2. For `func load(completion: @escaping (Result<Data, Error>) -> Void)` it generates
//    `func load() async throws -> Data`.
// 3. Inside — a `withCheckedThrowingContinuation` that calls the original.
//
// Done when
// - [ ] Both versions of the function are available
// - [ ] The async version works, proven by a test
// - [ ] Parameters other than completion carry over to the async version in the same order
// - [ ] A function without a completion parameter produces a clear macro error
//
// Pitfall
// You have to parse `Result<Success, Failure>` in the completion syntactically to know the async version's return type.
// If the completion has the shape `(Data?, Error?) -> Void`, that's a different case; either support both or explicitly
// reject the second.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MAC09PracticePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = []
}
