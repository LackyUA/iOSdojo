// MAC-14 · `@Mockable` · ⏱ 30 min — practice, public declaration
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(peer, names: prefixed(Mock)) macro Mockable()` on a protocol.
// 2. It generates `final class MockX: X` with call recording and configurable return values.
// 3. Support: methods with parameters, `async`, `throws`, `var` with `get`/`set`.
//
// Done when
// - [ ] A mock for a protocol with 4 different methods is generated and compiles
// - [ ] `mock.loadCallCount` and `mock.loadReceivedArguments` are available
// - [ ] An `async throws` method has a configurable `loadResult: Result<Data, Error>`
// - [ ] An `associatedtype` in the protocol produces a clear error (or is supported — but deliberately)
//
// Pitfall
// This is the biggest kata in the section by amount of SwiftSyntax code. Start with a single method without parameters,
// and add features one at a time, with a test for each.
