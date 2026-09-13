// SRV-07 · Middleware chain · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1.
//    `protocol Middleware { func intercept(_ request: URLRequest, next: (URLRequest) async throws -> (Data, HTTPURLResponse)) async throws -> (Data, HTTPURLResponse) }`.
// 2. Three implementations: `AuthMiddleware` (adds a header), `LoggingMiddleware`, `RetryMiddleware`.
// 3. `struct ChainedHTTPClient: HTTPClient` that builds the chain from an array of middleware.
//
// Done when
// - [ ] Execution order: auth → logging → retry → network, then back in reverse order
// - [ ] A log proves the order — there's a "before" and "after" entry for each layer
// - [ ] Removing one middleware from the array requires no changes to the rest
// - [ ] There is no `class AuthenticatedLoggingRetryingClient: HTTPClient`
//
// Pitfall
// Building the chain from an array is a right-to-left `reduce` over closures. It's the easiest place to mix up the
// order; verify it with a log, not in your head.
