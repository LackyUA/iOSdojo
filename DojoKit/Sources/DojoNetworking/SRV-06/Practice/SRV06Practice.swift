// SRV-06 · Minimal DI container · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `final class Container` with `[ObjectIdentifier: () -> Any]` storage.
// 2. `func register<T>(_ type: T.Type, factory: @escaping () -> T)` and `func resolve<T>(_ type: T.Type) -> T`.
// 3. Add two modes: a new instance on every `resolve`, and a singleton scoped to the container.
//
// Done when
// - [ ] Registering and resolving three different types works
// - [ ] An unregistered type produces a clear crash/error, not an `as!` crash
// - [ ] Singleton mode returns the same object twice, transient returns different ones
// - [ ] In a comment — 3 reasons why plain init injection is better in a real project
//
// Pitfall
// `ObjectIdentifier(T.self)` isn't as reliable for protocols as it is for classes. `String(describing: T.self)` is
// simpler, but it breaks on generics too. This is exactly why containers aren't free.
