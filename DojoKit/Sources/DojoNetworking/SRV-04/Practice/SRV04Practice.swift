// SRV-04 · `APIRequest` with `associatedtype` · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1.
//    `protocol APIRequest { associatedtype Response: Decodable; var path: String { get }; var method: HTTPMethod { get }; var query: [QueryItem] { get }; var body: Data? { get } }`.
// 2. Default implementations in an extension for `method = .get`, `query = []`, `body = nil`.
// 3. `func send<R: APIRequest>(_ request: R) async throws -> R.Response` in the service.
//
// Done when
// - [ ] Declaring a new endpoint is a single 3-line struct
// - [ ] The response type is inferred automatically: `let user = try await api.send(GetUser(id: id))`
// - [ ] No `as!` and no explicit `Response.self` at the call site
// - [ ] Three different endpoints (GET, POST with a body, GET with a query) work through the same `send`
//
// Pitfall
// If `Response` is `Void` (a DELETE with no body), `Decodable` won't work. You need either `EmptyResponse: Decodable`
// or a separate `send` overload.
