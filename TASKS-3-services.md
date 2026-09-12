# Tasks · Part 3: Data, services, concurrency

`COD` · `SRV` · `CNC` — 25 katas

---

## COD — Codable, parsing, errors

### `COD-01` · Nested `Codable` ⏱ 15

**Task**
1. Take JSON where the field you need sits three levels deep: `{"data": {"user": {"profile": {"name": "..."}}}}`.
2. Decode it into a **flat** model `User { name: String, avatarURL: URL? }` using a custom `init(from:)` and `nestedContainer`.
3. Add a field whose JSON key is snake_case, via `CodingKeys`.

**Done when**
- [ ] The model is flat — no three intermediate structs `DataDTO`/`UserDTO`/`ProfileDTO`
- [ ] A missing optional key doesn't break decoding
- [ ] `decodeIfPresent` is used exactly where the field is genuinely optional

**Pitfall** `nestedContainer(keyedBy:forKey:)` throws if the key is missing. For an optional nesting level you need `try?` or a separate `contains` check.

---

### `COD-02` · DTO → Domain mapper ⏱ 15

**Task**
1. `UserDTO` (everything optional, strings instead of dates and enums) and `User` (nothing optional without a reason).
2. `func map(_ dto: UserDTO) throws -> User` with an `enum MappingError` case for each missing required field.
3. Test: a DTO with `nil` in a required field produces a specific error, not `nil`.

**Done when**
- [ ] `User` has no optionals that were optional only "because that's what the backend sends"
- [ ] The error names **exactly which** field is missing
- [ ] The test for a "complete" DTO checks every field — none is forgotten in the mapping

**Pitfall** A mapper that silently substitutes defaults (`dto.name ?? ""`) masks a backend problem. Either throw, or document the default as a business decision.

---

### `COD-03` · `AppError` at the boundary ⏱ 15

**Task**
1. `enum AppError: Error { case offline, serverUnavailable, badData, unauthorized, unknown }`.
2. `init(_ error: Error)` that maps `URLError` (`.notConnectedToInternet`, `.timedOut`), `DecodingError` and HTTP status codes.
3. Add `LocalizedError` with an `errorDescription` for each case.

**Done when**
- [ ] No `URLError` or `DecodingError` leaks through
- [ ] `.unknown` carries the original error for logs, but not for the UI
- [ ] A test with 5 different input errors produces 5 different cases

**Pitfall** A `DecodingError` in production is a **backend or client** bug, not a user problem. Mapping it to "Check your internet connection" is wrong; it needs its own case.

---

### `COD-04` · Enum with a fallback ⏱ 15

**Task**
1. `enum OrderStatus: String, Decodable { case pending, shipped, delivered, unknown }`.
2. Implement `init(from decoder:)` so an unknown string yields `.unknown` instead of an error.
3. Test: JSON with the status `"returned"` decodes successfully.

**Done when**
- [ ] An unknown value doesn't break decoding of the whole object
- [ ] `.unknown` keeps the original string (for logs/analytics)
- [ ] A `switch` on the status in the UI handles `.unknown` explicitly

**Pitfall** If `.unknown` doesn't keep the raw string, you won't find out that the backend added a new status. Make it `case unknown(String)`.

---

### `COD-05` · Lossy array ⏱ 15

**Task**
1. `struct LossyArray<Element: Decodable>: Decodable` with an `elements: [Element]` property.
2. Inside — an `unkeyedContainer` and a loop that catches the error on each element and skips it.
3. Add `errors: [Error]` for reporting.

**Done when**
- [ ] JSON with 5 objects, where the 2nd is malformed, yields 4 elements
- [ ] `errors.count == 1` and the error includes the index
- [ ] Used in a real model: `@LossyArray var items: [Item]` or via a wrapper property

**Pitfall** After a failed `decode`, the `UnkeyedDecodingContainer` cursor doesn't advance on its own — you need an "empty" placeholder type to skip the element: `_ = try? container.decode(AnyDecodable.self)`.

---

### `COD-06` · Typed throws ⏱ 30

**Task**
1. `func load() throws(LoadError) -> Data` with `enum LoadError: Error`.
2. Call it and make sure the `catch` is **exhaustive** without a `default`.
3. Write a second version with plain (untyped) `throws` and compare what changed at the call site.

**Done when**
- [ ] `do/catch` with typed throws compiles without a trailing `catch { }`
- [ ] Trying to throw a different error from the typed function doesn't compile
- [ ] In a comment — when typed throws hurts: a public API that may grow

**Pitfall** `throws(any Error)` == plain `throws`, `throws(Never)` == doesn't throw. Typed throws in a library's public API makes adding a new error case a breaking change.

---

## SRV — Service layer, networking, DI

### `SRV-01` · `DateProviding` ⏱ 15

**Task**
1. `protocol DateProviding { var now: Date { get } }`, `struct SystemDateProvider` and `struct FixedDateProvider`.
2. Take any type that uses `Date()` internally and inject the provider via init.
3. Write a test for "the subscription expired yesterday" logic without a single `sleep`.

**Done when**
- [ ] `grep "Date()"` over domain code returns 0 results
- [ ] The test is deterministic — a run in January and in July gives the same result
- [ ] A default init parameter value means production code doesn't have to pass the provider

**Pitfall** Don't forget the time zone and calendar — `Calendar.current` in a test is just as unstable as `Date()`. Inject it too.

---

### `SRV-02` · Typed query parameters ⏱ 15

**Task**
1. `struct QueryItem { let name: String; let value: String }` + factories for `Int`, `Bool`, `Date`, and arrays.
2. `func url(path: String, query: [QueryItem]) -> URL?` via `URLComponents`.
3. Check it with a parameter containing a space, a Cyrillic value, and an array `ids=1&ids=2`.

**Done when**
- [ ] The space and Cyrillic characters are escaped correctly
- [ ] The code has no string concatenation with `?` and `&`
- [ ] A `nil` parameter value doesn't end up in the URL as `key=nil`

**Pitfall** `URLComponents.url` returns an optional and can yield `nil` for an invalid `path` (e.g. one without a leading slash). Handle this explicitly, not with `!`.

---

### `SRV-03` · `HTTPClient` + mock ⏱ 30

**Task**
1. `protocol HTTPClient { func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) }`.
2. `struct URLSessionHTTPClient: HTTPClient` with a status code check (throws on 4xx/5xx).
3. `final class MockHTTPClient: HTTPClient` with a configurable result and recording of received requests.

**Done when**
- [ ] The mock lets you set either a successful response or an error
- [ ] The mock stores every received `URLRequest` for assertions
- [ ] Test for a 500 status: the client throws, and the error carries the code
- [ ] `MockHTTPClient` conforms to `Sendable` (or is an `actor`)

**Pitfall** In tests, `HTTPURLResponse` is created via `HTTPURLResponse(url:statusCode:httpVersion:headerFields:)`, which returns an optional. Add a helper so it doesn't clutter the tests.

---

### `SRV-04` · `APIRequest` with `associatedtype` ⏱ 30

**Task**
1. `protocol APIRequest { associatedtype Response: Decodable; var path: String { get }; var method: HTTPMethod { get }; var query: [QueryItem] { get }; var body: Data? { get } }`.
2. Default implementations in an extension for `method = .get`, `query = []`, `body = nil`.
3. `func send<R: APIRequest>(_ request: R) async throws -> R.Response` in the service.

**Done when**
- [ ] Declaring a new endpoint is a single 3-line struct
- [ ] The response type is inferred automatically: `let user = try await api.send(GetUser(id: id))`
- [ ] No `as!` and no explicit `Response.self` at the call site
- [ ] Three different endpoints (GET, POST with a body, GET with a query) work through the same `send`

**Pitfall** If `Response` is `Void` (a DELETE with no body), `Decodable` won't work. You need either `EmptyResponse: Decodable` or a separate `send` overload.

---

### `SRV-05` · `UserService` + tests ⏱ 30

**Task**
1. `struct UserService` with an injected `HTTPClient` and a `(UserDTO) throws -> User` mapper.
2. `func user(id: UserID) async throws -> User`.
3. Three tests: success, network error, malformed JSON.

**Done when**
- [ ] The tests make no real network call — check by run time (< 50 ms for all three)
- [ ] A test checks that the service built the **correct** URL, not just the result
- [ ] Malformed JSON yields `AppError.badData`, not `DecodingError`
- [ ] The service is a `struct`, not a `class` with a singleton

**Pitfall** The temptation is to test only the happy path. It's the error tests that prove the injection actually works.

---

### `SRV-06` · Minimal DI container ⏱ 30

**Task**
1. `final class Container` with `[ObjectIdentifier: () -> Any]` storage.
2. `func register<T>(_ type: T.Type, factory: @escaping () -> T)` and `func resolve<T>(_ type: T.Type) -> T`.
3. Add two modes: a new instance on every `resolve`, and a singleton scoped to the container.

**Done when**
- [ ] Registering and resolving three different types works
- [ ] An unregistered type produces a clear crash/error, not an `as!` crash
- [ ] Singleton mode returns the same object twice, transient returns different ones
- [ ] In a comment — 3 reasons why plain init injection is better in a real project

**Pitfall** `ObjectIdentifier(T.self)` isn't as reliable for protocols as it is for classes. `String(describing: T.self)` is simpler, but it breaks on generics too. This is exactly why containers aren't free.

---

### `SRV-07` · Middleware chain ⏱ 30

**Task**
1. `protocol Middleware { func intercept(_ request: URLRequest, next: (URLRequest) async throws -> (Data, HTTPURLResponse)) async throws -> (Data, HTTPURLResponse) }`.
2. Three implementations: `AuthMiddleware` (adds a header), `LoggingMiddleware`, `RetryMiddleware`.
3. `struct ChainedHTTPClient: HTTPClient` that builds the chain from an array of middleware.

**Done when**
- [ ] Execution order: auth → logging → retry → network, then back in reverse order
- [ ] A log proves the order — there's a "before" and "after" entry for each layer
- [ ] Removing one middleware from the array requires no changes to the rest
- [ ] There is no `class AuthenticatedLoggingRetryingClient: HTTPClient`

**Pitfall** Building the chain from an array is a right-to-left `reduce` over closures. It's the easiest place to mix up the order; verify it with a log, not in your head.

---

### `SRV-08` · `RetryPolicy` ⏱ 30

**Task**
1. `struct RetryPolicy { let maxAttempts: Int; let baseDelay: Duration; let jitter: ClosedRange<Double> }`.
2. `func delay(forAttempt n: Int, random: (ClosedRange<Double>) -> Double) -> Duration` — exponential, with jitter.
3. A test with a fixed `random` checks the exact values for 4 attempts.

**Done when**
- [ ] The test is deterministic: `random` is injected, not `Double.random`
- [ ] Delays grow exponentially: roughly 1s, 2s, 4s, 8s
- [ ] There's an upper bound (`maxDelay`), otherwise the 10th attempt would wait 17 minutes
- [ ] The policy knows **nothing** about networking — only about numbers

**Pitfall** Without jitter, every client retries at the same moment after a server outage — the "thundering herd". Jitter isn't an optimization, it's a necessity.

---

### `SRV-09` · Generic `Store<T>` ⏱ 30

**Task**
1. `protocol Persistence { func write(_ data: Data, key: String) throws; func read(key: String) throws -> Data? }`.
2. Two implementations: `FilePersistence`, `InMemoryPersistence` (Keychain is a bonus).
3. `struct Store<T: Codable>` on top of `Persistence` with `save(_:)`, `load()`, `delete()`.

**Done when**
- [ ] `Store<User>` and `Store<[Order]>` work without changes to the type
- [ ] Swapping `FilePersistence` for `InMemoryPersistence` is one line in a test
- [ ] `load()` on a missing key returns `nil`, doesn't throw
- [ ] A corrupted file produces a clear error, not a crash

**Pitfall** The coder (`JSONEncoder`) should also be injected, or at least configured — otherwise a `Date` gets saved in one format and read back in another after the defaults change.

---

### `SRV-10` · Typed analytics ⏱ 30

**Task**
1. `enum AnalyticsEvent { case screenViewed(name: String), purchaseCompleted(orderID: OrderID, amount: Money), searchPerformed(query: String, resultsCount: Int) }`.
2. `var name: String` and `var parameters: [String: Any]` as computed properties on the enum.
3. `protocol AnalyticsService { func track(_ event: AnalyticsEvent) }` + an implementation and a spy mock.

**Done when**
- [ ] `track("purchase_complete", ["amount": 5])` (with a typo and a missing required field) is no longer possible
- [ ] Adding an event is one case + two lines in a `switch`, and the compiler points to everywhere else that needs updating
- [ ] A spy in the test checks that the event was sent with the correct parameters
- [ ] `parameters` contains no `nil` values

**Pitfall** There's still a `[String: Any]` at the output — but now it's generated in one place and checked by one test, instead of being scattered across 40 screens.

---

### `SRV-11` · Singleton → injection ⏱ 30

**Task**
1. Take (or write) a `final class SettingsManager` with `static let shared` and 15 usage sites.
2. Extract `protocol SettingsProviding` and make `shared` its implementation.
3. Inject it into 3 sites via init, and leave the remaining 12 on `shared` — but marked `@available(*, deprecated)`.

**Done when**
- [ ] The three injected sites are tested without `shared`
- [ ] The compiler emits a warning for each of the remaining 12 usages — a visible work list
- [ ] `shared` isn't deleted: the code compiles and works
- [ ] In a comment — a plan for the order in which to migrate the rest

**Pitfall** Trying to remove a singleton in one commit means 200 changed files and a dead PR. A `deprecated` shim puts the compiler to work building your backlog.

---

## CNC — Concurrency

### `CNC-01` · `Result` → `async throws` ⏱ 15

**Task**
1. Write a legacy API: `func load(completion: @escaping (Result<Data, Error>) -> Void)`.
2. Add an `async throws` version via `withCheckedThrowingContinuation`.
3. Verify the continuation is resumed **exactly once** on every branch.

**Done when**
- [ ] Success, error and cancellation — all three paths work
- [ ] There's no path where completion isn't called (otherwise — an await that never returns)
- [ ] There's no path where completion is called twice (otherwise — a crash)
- [ ] `withCheckedThrowingContinuation` (not `unsafe`) — so the runtime catches mistakes

**Pitfall** The most common bug is `guard let self else { return }` inside the completion without resuming the continuation. The task hangs forever without a single log line.

---

### `CNC-02` · Fixing `Sendable` ⏱ 15

**Task**
1. Enable `-strict-concurrency=complete` (or `swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]`).
2. Take `final class Counter { var value = 0; func increment() }` and record all the warnings.
3. Fix it in **three** different ways: `actor`, `@MainActor`, and a struct with value semantics.

**Done when**
- [ ] Zero warnings in all three variants
- [ ] For each variant, a comment on when it's appropriate
- [ ] No `@unchecked Sendable` without locking and a justifying comment

**Pitfall** `@unchecked Sendable` isn't a fix, it's a promise to the compiler. If you make it, you must have an `NSLock`/`DispatchQueue` inside and a comment explaining exactly what guarantees it.

---

### `CNC-03` · Real cancellation ⏱ 15

**Task**
1. Write `func process(_ items: [Item]) async throws` with a loop and heavy work on each item.
2. Run it in a `Task`, call `cancel()` after 100 ms, and log that the loop **kept going**.
3. Add `try Task.checkCancellation()` to the loop and repeat.

**Done when**
- [ ] The first variant proves the problem: all items were processed after cancel
- [ ] The second variant stops at the very first item after cancel
- [ ] `CancellationError` propagates upward instead of being swallowed
- [ ] Resources (an open file, a transaction) are released in `defer`

**Pitfall** `Task.cancel()` just sets a flag. Cancellation is cooperative: if your code doesn't check for it, it won't happen.

---

### `CNC-04` · Abstract `Clock` ⏱ 15

**Task**
1. Write debounce or timeout logic that uses `Task.sleep`.
2. Replace it with an injected `any Clock<Duration>` (or your own `protocol Sleeping`).
3. In the test, substitute a fake clock that doesn't sleep, and verify the logic.

**Done when**
- [ ] A test for a 30-second timeout runs in milliseconds
- [ ] 100 runs — 100 times green (no flakiness)
- [ ] Production code uses `ContinuousClock` by default

**Pitfall** `ContinuousClock` vs `SuspendingClock`: the former keeps ticking while the app is in the background, the latter doesn't. Network timeouts need `ContinuousClock`.

---

### `CNC-05` · Actor cache with TTL ⏱ 30

**Task**
1. `actor TTLCache<Key: Hashable, Value>` with `[Key: (value: Value, expiresAt: Date)]` storage.
2. `func value(for key: Key) async -> Value?` — an expired entry returns `nil` and is removed.
3. Add `func value(for key: Key, orLoad load: @Sendable () async throws -> Value) async throws -> Value`.

**Done when**
- [ ] No `NSLock` and no `DispatchQueue`
- [ ] An expired value is never returned — tested with the fake clock from `CNC-04`
- [ ] 10 concurrent requests for the same key call `load` exactly once (this partly overlaps with `CNC-07`)
- [ ] Compiles without `Sendable` warnings when `Value: Sendable`

**Pitfall** An `await` inside an actor method creates a **suspension point**: the state may have changed after it. Re-check the storage after `await load()`.

---

### `CNC-06` · `AsyncStream` over a callback ⏱ 30

**Task**
1. Take a callback-based API (e.g. `NotificationCenter` or your own `LocationManagerDelegate`).
2. Wrap it in an `AsyncStream` via `AsyncStream { continuation in ... }`.
3. Implement `continuation.onTermination` to unsubscribe.

**Done when**
- [ ] `for await event in stream` receives events
- [ ] Exiting the loop (`break`) triggers `onTermination` — proven by a log
- [ ] No leak: the observer unsubscribes and the object is deinitialized
- [ ] `BufferingPolicy` (`.unbounded` or `.bufferingNewest(1)`) is chosen deliberately, with a justification

**Pitfall** The default `.unbounded` means that if the consumer is slower than the producer, memory grows without limit. Frequent events (gestures, location) need `.bufferingNewest(1)`.

---

### `CNC-07` · Request deduplication ⏱ 30

**Task**
1. `actor ImageLoader` with `[URL: Task<Data, Error>]` storage.
2. `func load(_ url: URL) async throws -> Data`: if a task already exists — `await` it, otherwise create one.
3. Test: 10 concurrent `load` calls for the same URL → exactly 1 network call.

**Done when**
- [ ] The mock client's call counter shows `1`, not `10`
- [ ] All 10 callers received the same result
- [ ] The task is removed from storage once it completes
- [ ] A failed request doesn't leave a "poisoned" task in the cache forever

**Pitfall** If you don't remove the task after it completes, the very first error gets cached forever — subsequent requests keep failing even though the network is back.

---

### `CNC-08` · `TaskGroup` with partial success ⏱ 30

**Task**
1. Three independent requests (profile, settings, notifications) via `withThrowingTaskGroup`.
2. Variant A: any error — the whole operation fails.
3. Variant B: the result is `(profile: Profile, settings: Settings?, notifications: [Note]?)`, where only the profile is critical.

**Done when**
- [ ] Variant A: an error in the second request cancels the third (proven by a log)
- [ ] Variant B: a notifications failure doesn't break the screen
- [ ] Both variants run **concurrently**, not sequentially — measured by timing
- [ ] In a comment — the rule: what's critical and what degrades gracefully

**Pitfall** Three sequential `await`s look almost the same as a group, but take three times as long. Measure the time — it's the only way to be sure the parallelism is real.

---

**Next:** `TASKS-4` — state, UI, principles, tests.
