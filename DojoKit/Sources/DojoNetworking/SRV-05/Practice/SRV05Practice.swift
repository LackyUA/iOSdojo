// SRV-05 · `UserService` + tests · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `struct UserService` with an injected `HTTPClient` and a `(UserDTO) throws -> User` mapper.
// 2. `func user(id: UserID) async throws -> User`.
// 3. Three tests: success, network error, malformed JSON.
//
// Done when
// - [ ] The tests make no real network call — check by run time (< 50 ms for all three)
// - [ ] A test checks that the service built the correct URL, not just the result
// - [ ] Malformed JSON yields `AppError.badData`, not `DecodingError`
// - [ ] The service is a `struct`, not a `class` with a singleton
//
// Pitfall
// The temptation is to test only the happy path. It's the error tests that prove the injection actually works.
