// SOL-08 · Find an LSP violation · ⏱ 45 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take your own protocol with 3+ implementations (or `Repository` from `GEN-05`).
// 2. Find an implementation where a method calls `fatalError`, does nothing, or has stricter preconditions.
// 3. Fix it in one of three ways: split the protocol, make the method optional in the contract, or change the
//    hierarchy.
//
// Done when
// - [ ] The violation is described concretely: "`ReadOnlyRepository.save` throws — a client can't substitute it for
//       `InMemoryRepository`"
// - [ ] The fix didn't add `if repository is ReadOnly` at the call site
// - [ ] After the fix, any implementation can be substituted for another without changing the client
// - [ ] A test that runs the same set of checks against every implementation is green
//
// Pitfall
// A shared test suite for all implementations of a protocol is the most reliable LSP detector. If you have to skip
// tests for one implementation, the contract is broken.
