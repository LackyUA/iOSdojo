// GEN-05 · `AnyRepository<T>` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1.
//    `protocol Repository { associatedtype Model; func all() async throws -> [Model]; func save(_ model: Model) async throws }`.
// 2. Implement `InMemoryRepository<Item>` and `AnyRepository<Model>`.
// 3. Add a `let repo: AnyRepository<Item>` property to a service and inject a fake in a test.
//
// Done when
// - [ ] The service doesn't know the concrete repository type
// - [ ] The test injects the fake without any change to the service code
// - [ ] `AnyRepository` forwards errors and `async` transparently
//
// Pitfall
// Closures that store `async throws` need the exact type: `@Sendable () async throws -> [Model]`. Without `@Sendable`
// you get a warning in Swift 6.
