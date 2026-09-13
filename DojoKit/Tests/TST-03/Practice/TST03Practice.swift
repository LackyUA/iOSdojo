// TST-03 · Stub, spy, mock · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Write three different test doubles for `HTTPClient` from `SRV-03`.
// 2. Stub: only returns a canned value. Spy: also records calls. Mock: has expectations and fails if they aren't met.
// 3. Write three tests — each uses the double where it fits.
//
// Done when
// - [ ] The "mapper transformed the data correctly" test uses a stub (it doesn't care how it was called)
// - [ ] The "service built the correct URL" test uses a spy
// - [ ] The "cache doesn't hit the network twice" test uses a mock with an expectation
// - [ ] In a comment: the selection rule in one sentence
//
// Pitfall
// A mock with expectations makes a test brittle: it fails on any implementation change. Use it only when **the fact of
// the call** is the behavior under test.
