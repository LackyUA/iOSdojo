// SRV-03 · `HTTPClient` + mock · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `protocol HTTPClient { func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) }`.
// 2. `struct URLSessionHTTPClient: HTTPClient` with a status code check (throws on 4xx/5xx).
// 3. `final class MockHTTPClient: HTTPClient` with a configurable result and recording of received requests.
//
// Done when
// - [ ] The mock lets you set either a successful response or an error
// - [ ] The mock stores every received `URLRequest` for assertions
// - [ ] Test for a 500 status: the client throws, and the error carries the code
// - [ ] `MockHTTPClient` conforms to `Sendable` (or is an `actor`)
//
// Pitfall
// In tests, `HTTPURLResponse` is created via `HTTPURLResponse(url:statusCode:httpVersion:headerFields:)`, which returns
// an optional. Add a helper so it doesn't clutter the tests.
