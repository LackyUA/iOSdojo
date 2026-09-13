// COD-03 · `AppError` at the boundary · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `enum AppError: Error { case offline, serverUnavailable, badData, unauthorized, unknown }`.
// 2. `init(_ error: Error)` that maps `URLError` (`.notConnectedToInternet`, `.timedOut`), `DecodingError` and HTTP
//    status codes.
// 3. Add `LocalizedError` with an `errorDescription` for each case.
//
// Done when
// - [ ] No `URLError` or `DecodingError` leaks through
// - [ ] `.unknown` carries the original error for logs, but not for the UI
// - [ ] A test with 5 different input errors produces 5 different cases
//
// Pitfall
// A `DecodingError` in production is a **backend or client** bug, not a user problem. Mapping it to "Check your
// internet connection" is wrong; it needs its own case.
