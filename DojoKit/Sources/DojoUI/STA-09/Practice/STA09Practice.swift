// STA-09 · End-to-end search · ⏱ 60 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. 300 ms debounce on input (via `AsyncStream` or `Task` cancellation).
// 2. Cancel the previous request on new input.
// 3. Full path: `SearchQuery` → `APIRequest` (`SRV-04`) → DTO → domain (`COD-02`) → UI model (`MOD-05`) → states
//    (`STA-02`).
// 4. Tests: debounce, cancellation, empty result, error.
//
// Done when
// - [ ] Typing "swift" character by character makes one network call, not five
// - [ ] A stale request's result arriving after a newer one is not displayed
// - [ ] An empty string cancels the request and clears results without a call
// - [ ] All four tests are deterministic (using the `Clock` from `CNC-04`)
// - [ ] The whole test run takes < 200 ms
//
// Pitfall
// The "stale result" race is the nastiest search bug. Cancelling the `Task` isn't enough: make sure a result already in
// flight is discarded based on a request token.
