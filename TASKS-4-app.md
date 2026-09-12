# Tasks · Part 4: State, UI, principles, tests

`STA` · `UI` · `SOL` · `TST` — 28 katas

---

## STA — State & architecture

### `STA-01` · Pure pagination ⏱ 30

**Task**
1. `struct PageRequest { let offset: Int; let limit: Int }` and `struct Page<T> { let items: [T]; let total: Int }`.
2. `func nextRequest(after page: Page<T>, current: PageRequest) -> PageRequest?` — a pure function.
3. Edge-case tests: first page, last page, `total == 0`, `total` smaller than `limit`, partial last page.

**Done when**
- [ ] The function has no access to the network or to state — only its parameters
- [ ] All 5 edge cases are covered by tests
- [ ] The last page yields `nil`, not a request with `offset > total`
- [ ] The file has no UIKit/SwiftUI import

**Pitfall** The most common bug is "the last page is full". If `total = 20` and `limit = 10`, the second page must be followed by `nil`, not a third request.

---

### `STA-02` · Pagination as a state machine ⏱ 30

**Task**
1. `enum FeedState { case idle, loading, loaded([Item], hasMore: Bool), loadingMore([Item]), exhausted([Item]), failed(AppError, retry: [Item]) }`.
2. `enum FeedAction { case load, loadMore, received(Page<Item>), failed(AppError), retry }`.
3. A transition table in a test: for every (state, action) pair — the expected new state or "ignored".

**Done when**
- [ ] `loadMore` in `.loading` does nothing (doesn't start a second request)
- [ ] `loadMore` in `.exhausted` does nothing
- [ ] The transition table covers every combination — none marked "can't happen"
- [ ] It's impossible to be in `loading` and `failed` at the same time

**Pitfall** It's tempting to write `case loading(previousItems: [Item], isFirstLoad: Bool)` and start piling up flags. If a `Bool` shows up in the enum, check whether it should be a separate case.

---

### `STA-03` · Pure `reduce` ⏱ 30

**Task**
1. Take `STA-02` and extract the logic into `func reduce(_ state: FeedState, _ action: FeedAction) -> FeedState`.
2. The function must be `static`, side-effect free and not `async`.
3. Describe side effects separately: `func effects(for action: FeedAction, state: FeedState) -> [Effect]`.

**Done when**
- [ ] The test calls `reduce` directly, without a ViewModel and without `await`
- [ ] The same input always gives the same output — no `Date()`, `UUID()`, `random`
- [ ] The network call isn't made in `reduce`; it's described as an `Effect`
- [ ] A test with a sequence of 6 actions checks the final state

**Pitfall** If a `Task { ... }` sneaks into `reduce`, it's no longer a pure function and the tests become async again. An effect must be **data**, not execution.

---

### `STA-04` · Undo/redo ⏱ 30

**Task**
1. `protocol Command { func execute(on state: inout TaskList); func undo(on state: inout TaskList) }`.
2. Three commands: `AddTask`, `RemoveTask`, `ToggleCompletion`.
3. `struct CommandHistory` with `undoStack`, `redoStack`, `perform(_:)`, `undo()`, `redo()`.

**Done when**
- [ ] The sequence add → toggle → remove → undo×3 restores exactly the initial state
- [ ] `redo` after `undo` replays the action
- [ ] A new action after `undo` clears `redoStack`
- [ ] `RemoveTask.undo` puts the element back **at the same position**, not at the end

**Pitfall** `RemoveTask` must remember both the element and its index during `execute`. That means the command holds mutable state — which is fine, but it should be a conscious choice.

---

### `STA-05` · Repository with `AsyncStream` ⏱ 30

**Task**
1. `actor ItemRepository` with `all()`, `add(_:)`, `remove(_:)` and `var changes: AsyncStream<[Item]>`.
2. Support **multiple** subscribers (each gets its own stream).
3. Two "screens" subscribe, one adds an item — both see the change.

**Done when**
- [ ] Both subscribers received an update after a single `add`
- [ ] Unsubscribing one doesn't break the other
- [ ] A new subscriber gets the current state immediately, without waiting for the next change
- [ ] `deinit`/`onTermination` removes the subscriber from the list

**Pitfall** By default, `AsyncStream` is one consumer per stream. For broadcasting, keep an array of `continuation`s and send to each one manually.

---

### `STA-06` · Feature flags via Strategy ⏱ 30

**Task**
1. `protocol FeatureFlagSource { func value(for key: FeatureKey) -> Bool? }` (from `STD-05`).
2. Three implementations: `RemoteSource`, `LocalDefaultsSource`, `DebugOverrideSource`.
3. `struct FeatureFlags` with an ordered array of sources — the first one to return non-`nil` wins.

**Done when**
- [ ] Debug override beats remote — proven by a test
- [ ] No `if isDebug` inside `FeatureFlags`
- [ ] Adding a fourth source doesn't change any existing type
- [ ] If every source returns `nil`, the default defined alongside the key is used

**Pitfall** Source order is configuration, not a constant in code. Pass it through init, otherwise a test can't verify a different order.

---

### `STA-07` · Remote + cache behind one protocol ⏱ 45

**Task**
1. `protocol ItemSource { func items() async throws -> [Item] }`.
2. `RemoteItemSource`, `CachedItemSource`, and `CompositeItemSource`, which tries the cache, then the network.
3. Three composition strategies: `cacheFirst`, `remoteFirst`, `cacheThenRemote` (returns twice via a stream).

**Done when**
- [ ] The ViewModel takes `any ItemSource` and doesn't know the cache exists
- [ ] Switching strategy is one line at the composition root
- [ ] The ViewModel has no `if hasCache`
- [ ] A `cacheFirst` test with an empty cache goes to the network

**Pitfall** `cacheThenRemote` doesn't fit `() async throws -> [Item]` — it needs an `AsyncStream` or a separate protocol. That's the signal the abstraction is leaking; resolve it explicitly, not with a hack.

---

### `STA-08` · Router as a protocol ⏱ 45

**Task**
1. `protocol OrderListRouting { func showDetail(for id: OrderID); func showFilters() }`.
2. The ViewModel calls protocol methods without knowing about `NavigationPath` or `NavigationStack`.
3. Two implementations: a real `NavigationRouter` and a `SpyRouter` for tests.

**Done when**
- [ ] The ViewModel has no SwiftUI import
- [ ] A test verifies that tapping a row called `showDetail(for:)` with the correct ID
- [ ] Replacing `NavigationStack` with a modal doesn't touch the ViewModel
- [ ] The protocol names **domain actions**, not UI ones (`showDetail`, not `pushViewController`)

**Pitfall** If a `dismiss()` or `popToRoot()` method shows up in the protocol, the abstraction has leaked. The domain knows "order opened", not "screen pushed".

---

### `STA-09` · End-to-end search ⏱ 60

**Task**
1. 300 ms debounce on input (via `AsyncStream` or `Task` cancellation).
2. Cancel the previous request on new input.
3. Full path: `SearchQuery` → `APIRequest` (`SRV-04`) → DTO → domain (`COD-02`) → UI model (`MOD-05`) → states (`STA-02`).
4. Tests: debounce, cancellation, empty result, error.

**Done when**
- [ ] Typing "swift" character by character makes **one** network call, not five
- [ ] A stale request's result arriving after a newer one is **not** displayed
- [ ] An empty string cancels the request and clears results without a call
- [ ] All four tests are deterministic (using the `Clock` from `CNC-04`)
- [ ] The whole test run takes < 200 ms

**Pitfall** The "stale result" race is the nastiest search bug. Cancelling the `Task` isn't enough: make sure a result already in flight is discarded based on a request token.

---

### `STA-10` · Master → Detail with optimistic updates ⏱ 60

**Task**
1. The list and the detail screen share one `ItemRepository` (`STA-05`).
2. A change in the detail screen is applied locally **immediately**, then sent to the server.
3. A server error rolls the change back and shows a message.

**Done when**
- [ ] A change in the detail screen shows up in the list without a manual refresh
- [ ] The UI reacts to the change in < 16 ms (i.e. before the network call)
- [ ] An error rolls state back **exactly** to the previous one — the test compares snapshots
- [ ] Two quick consecutive changes don't leave the state "mixed"

**Pitfall** Rolling back with two concurrent changes isn't "restore the previous value" — it's "reapply the last confirmed state". Keep `confirmed` and `pending` separate.

---

### `STA-11` · Offline-first ⏱ 60

**Task**
1. Writes always go to local storage (`SRV-09`) and to a sync queue.
2. `SyncEngine` flushes the queue when the network is available; the queue survives a relaunch.
3. A conflict (the server has a newer version) is resolved with one explicit strategy: last-write-wins **or** merge — your choice, with a rationale.

**Done when**
- [ ] Three offline changes, then the network comes back → three calls in the correct order
- [ ] Relaunching the app doesn't lose the queue
- [ ] The conflict is reproduced in a test, and the result matches the documented strategy
- [ ] Resending an already-applied change is idempotent (doesn't duplicate the record)

**Pitfall** Idempotency isn't optional. Without a client-side operation ID, a network retry creates a duplicate, and the user will see it.

---

## UI — SwiftUI

### `UI-01` · Login screen ⏱ 30

**Task**
1. `@Observable final class LoginViewModel` with `email`, `password`, `state`.
2. Live validation: the button is enabled only with a valid email and a password ≥ 8 characters.
3. State: `idle`, `submitting`, `failed(String)`; fields are disabled during `submitting`.

**Done when**
- [ ] The ViewModel is tested without rendering the View
- [ ] The button is disabled when fields are empty, proven by a test on `canSubmit`
- [ ] A repeated tap during `submitting` does nothing
- [ ] The View has no `if email.contains("@")` — all logic lives in the VM

**Pitfall** `@Observable` won't work if the VM is created as `let vm = LoginViewModel()` right inside `body`. You need `@State private var vm`.

---

### `UI-02` · `EnvironmentKey` for a service ⏱ 30

**Task**
1. `struct UserServiceKey: EnvironmentKey { static let defaultValue: any UserServicing = FailingUserService() }`.
2. An `extension EnvironmentValues` with a computed property.
3. A preview with a mock service that returns data immediately, and a second preview with a service that throws an error.

**Done when**
- [ ] Both previews render without a network
- [ ] `defaultValue` is a service that **fails with a clear message**, not an empty stub
- [ ] Swapping the service for a subtree is a single `.environment(...)`
- [ ] In a comment: when Environment is better than init injection, and when it's worse

**Pitfall** A `defaultValue` that silently returns empty data hides a forgotten injection. Let it crash in debug: `fatalError` or `assertionFailure`.

---

### `UI-03` · `@MainActor` and heavy work ⏱ 30

**Task**
1. `@MainActor @Observable final class ReportViewModel` with a method that processes 100,000 records.
2. First do the work directly in the method and measure the UI freeze (the spinner will stop).
3. Move the computation into a `nonisolated` function or a separate actor, and return the result to main.

**Done when**
- [ ] The first version proves the freeze — the animation stops
- [ ] Second version: the animation doesn't stop
- [ ] Assigning the result to the VM property happens on main (the compiler guarantees it)
- [ ] Zero `Sendable` warnings

**Pitfall** `Task { }` inside a `@MainActor` class inherits the main actor — the work does **not** go to the background. You need `Task.detached` or a `nonisolated` function.

---

### `UI-04` · List screen with every state ⏱ 45

**Task**
1. States: `loading` (skeleton or spinner), `empty` (illustration + CTA), `failed` (text + Retry), `content`.
2. `loadingMore` at the bottom of the list — separate from the initial `loading`.
3. Pull-to-refresh that does **not** show a full-screen spinner.

**Done when**
- [ ] All 5 states render in 5 separate previews
- [ ] `empty` differs from `failed` in both appearance and CTA
- [ ] Retry after an error doesn't reset scroll or flash an empty screen
- [ ] Refresh with existing content doesn't hide the content
- [ ] The `switch` over state in `body` is exhaustive without `default`

**Pitfall** "Empty" and "error" are different states with different actions. One shared "Something went wrong" screen for both is a product bug that only shows up in the design.

---

### `UI-05` · Design system component ⏱ 45

**Task**
1. `struct Card<Content: View>: View` with a `@ViewBuilder` init.
2. Three style variants via a dedicated type: `CardStyle` (`plain`, `elevated`, `outlined`) — not via `Bool` parameters.
3. Bonus: a custom `CardStyle` protocol in the style of `ButtonStyle`, with a `.cardStyle(_:)` modifier.

**Done when**
- [ ] `Card { Text("hi") }` compiles without an explicit type
- [ ] The three styles render side by side in one preview
- [ ] Adding a fourth style doesn't change `Card`
- [ ] The component has no hardcoded spacing — everything comes from tokens (`Spacing.m`)
- [ ] Works in light and dark themes (checked in previews)

**Pitfall** `init(isElevated: Bool, hasBorder: Bool, isCompact: Bool)` is 8 combinations, of which 3 are valid. A style as a type makes the other 5 unrepresentable.

---

## SOL — Principles & refactoring

### `SOL-01` · Two pure functions ⏱ 5

**Task**
1. Write (or find) a 15-line function with three `if`s that computes, formats and logs.
2. Extract a pure computation function and a pure formatting function.
3. Leave logging in the caller.

**Done when**
- [ ] Both extracted functions are tested without mocks
- [ ] Each function has one reason to change — and you can name it
- [ ] The original function is down to 3 lines: compute, format, log

**Pitfall** If the extracted "pure" function still takes 5 parameters and has an `if`, you split by lines, not by responsibility.

---

### `SOL-02` · Type check → polymorphism ⏱ 15

**Task**
1. Write "bad" code: `func area(of shape: Any) -> Double` with three `if let x = shape as? Circle`.
2. Replace it with `protocol Shape { var area: Double { get } }`.
3. Add a fourth shape — and make sure no existing file changed.

**Done when**
- [ ] Zero `as?` in the final code
- [ ] Adding `Triangle` is one new file, 0 changed
- [ ] The `switch` on type hasn't moved somewhere else in disguise

**Pitfall** Sometimes `as?` is right: when types come from someone else's framework and you can't add a conformance. Tell "don't want to" apart from "can't".

---

### `SOL-03` · Split a fat protocol ⏱ 15

**Task**
1. Take `protocol UserService` with 8 methods (profile, avatar, settings, account deletion).
2. Find two clients, each using 2–3 methods.
3. Split it into `ProfileReading`, `AvatarUpdating`, `AccountDeleting`; one type conforms to all three.

**Done when**
- [ ] The mock for the profile test implements 2 methods, not 8
- [ ] The real implementation didn't change — only conformances were added
- [ ] Each client depends only on what it uses
- [ ] No `UserServicing: ProfileReading & AvatarUpdating & AccountDeleting` protocol "for convenience"

**Pitfall** ISP isn't measured by the number of methods in a protocol, but by the number of methods a specific client **doesn't need**. An 8-method protocol where every client needs all 8 is fine.

---

### `SOL-04` · DRY that shouldn't be fixed ⏱ 15

**Task**
1. Find two similar blocks in your code (or write them: email validation at sign-up and when changing the email in the profile).
2. Merge them in your head and list what happens when one of the requirements changes.
3. Write the decision in a comment: merge or not, and why.

**Done when**
- [ ] At least one scenario is described where merging causes a problem
- [ ] The criterion is stated: "same code" ≠ "same reason to change"
- [ ] The decision is made explicitly, not by default

**Pitfall** The most expensive mistake is merging two blocks that are similar **by accident**. A year later an `if isRegistration` appears inside the shared function, and the real pain begins.

---

### `SOL-05` · Breaking up a God object ⏱ 30

**Task**
1. Write (or take) an 80+ line `ProfileViewController`/`ProfileManager` that handles networking, caching, validation, formatting and navigation.
2. List its responsibilities and name the reason to change for each.
3. Extract three types. The original stays as a coordinator.

**Done when**
- [ ] The three new types are tested independently
- [ ] The coordinator contains no business logic — only the sequence of calls
- [ ] None of the three types knows about the other two (only via protocols or via the coordinator)
- [ ] The total line count has probably grown — and that's fine

**Pitfall** Splitting into `ProfileHelper`, `ProfileUtils`, `ProfileManager2` is the same problem with new names. Each type should be named after its responsibility.

---

### `SOL-06` · Three functions → one ⏱ 30

**Task**
1. Write three nearly identical functions: `fetchUsers`, `fetchOrders`, `fetchProducts` — differing only in URL and response type.
2. Merge them into a generic (effectively `SRV-04`).
3. Then **complicate** it: `fetchOrders` needs its own pagination handling. Decide whether to keep it in the shared function.

**Done when**
- [ ] The three functions are reduced to one
- [ ] After the complication, an explicit decision is made and the rationale written down
- [ ] If an `isPaginated: Bool` parameter was added, a comment explains why that's acceptable (or why not)

**Pitfall** This kata is about the boundary. A generic with 6 configuration parameters is worse than three simple functions. You need a feel for the moment an abstraction becomes more expensive than duplication.

---

### `SOL-07` · Composable validation ⏱ 45

**Task**
1. Take `GEN-08` (witness) or `GEN-04` (erasure).
2. Add operators: `&&` (both), `||` (at least one), `!`.
3. Build a password rule: `notEmpty && minLength(8) && (hasDigit || hasSymbol)`.
4. Add a new `notInBlocklist` rule **without changing any existing type**.

**Done when**
- [ ] The composition reads like a logical expression
- [ ] The new rule is one new type/factory, 0 changed files
- [ ] Errors from the `||` branch are aggregated meaningfully (not just the first one)
- [ ] A test with 6 different passwords

**Pitfall** `||` with errors is the hardest part. If both branches fail, which error do you show? Decide and document it: the first, the last, or both.

---

### `SOL-08` · Find an LSP violation ⏱ 45

**Task**
1. Take **your own** protocol with 3+ implementations (or `Repository` from `GEN-05`).
2. Find an implementation where a method calls `fatalError`, does nothing, or has stricter preconditions.
3. Fix it in one of three ways: split the protocol, make the method optional in the contract, or change the hierarchy.

**Done when**
- [ ] The violation is described concretely: "`ReadOnlyRepository.save` throws — a client can't substitute it for `InMemoryRepository`"
- [ ] The fix didn't add `if repository is ReadOnly` at the call site
- [ ] After the fix, any implementation can be substituted for another without changing the client
- [ ] A test that runs the **same** set of checks against every implementation is green

**Pitfall** A shared test suite for all implementations of a protocol is the most reliable LSP detector. If you have to skip tests for one implementation, the contract is broken.

---

### `SOL-09` · Legacy under tests ⏱ 60

**Task**
1. Take a "bad" 150+ line file (your own old code, or generate a deliberately bad one).
2. **First** cover the behavior with tests — without changing a single line. At least 6 tests.
3. Only then refactor: in small steps, with green tests after each one.
4. Record how many times the tests saved you from a regression.

**Done when**
- [ ] 6+ tests written **before** the first code change
- [ ] Tests are green before, during and after the refactoring
- [ ] No test was rewritten "to fit the new code" (otherwise it wasn't protecting behavior)
- [ ] The number is recorded: how many times a test failed during refactoring

**Pitfall** If the code can't be covered by tests without changing it, there's a recipe: a minimal "seam" — extract a method, turn a dependency into a parameter with a default. It's the safest kind of change, and you can make it before writing tests.

---

## TST — Testing

### `TST-01` · Parameterized tests ⏱ 15

**Task**
1. Take the validator from `GEN-04`/`SOL-07`.
2. `@Test(arguments: [...])` with an array of `(input, expected)` tuples — at least 8 cases.
3. A second test with `arguments:` of two collections (Cartesian product).

**Done when**
- [ ] One test instead of 8 copies
- [ ] Each case is visible separately in the report (not "1 test passed")
- [ ] One failing case doesn't hide the rest
- [ ] The case name in the report is readable — not `arg0`

**Pitfall** The Cartesian product of two 10-element arrays is 100 tests. If each one is heavy, the run time grows unnoticed; use `zip(...)` for pairwise cases when you don't need the product.

---

### `TST-02` · Fixtures from files ⏱ 15

**Task**
1. Put 3 JSON files in `Tests/Resources` and configure `resources:` in `Package.swift`.
2. A `func fixture(_ name: String) throws -> Data` helper using `Bundle.module`.
3. Rewrite the mapper test from `COD-02` to use files instead of in-code strings.

**Done when**
- [ ] No JSON in the tests — only file names
- [ ] The files are valid: you can open them in an editor and format them
- [ ] A missing file produces a clear error, not `nil`
- [ ] One of the files is a real (anonymized) backend response, not a made-up one

**Pitfall** `Bundle.main` doesn't work in SwiftPM tests — you need `Bundle.module`, and it only exists if resources are declared in the manifest.

---

### `TST-03` · Stub, spy, mock ⏱ 30

**Task**
1. Write three different test doubles for `HTTPClient` from `SRV-03`.
2. **Stub**: only returns a canned value. **Spy**: also records calls. **Mock**: has expectations and fails if they aren't met.
3. Write three tests — each uses the double where it fits.

**Done when**
- [ ] The "mapper transformed the data correctly" test uses a **stub** (it doesn't care how it was called)
- [ ] The "service built the correct URL" test uses a **spy**
- [ ] The "cache doesn't hit the network twice" test uses a **mock** with an expectation
- [ ] In a comment: the selection rule in one sentence

**Pitfall** A mock with expectations makes a test brittle: it fails on any implementation change. Use it only when **the fact of the call** is the behavior under test.

---

**Next:** `TASKS-5` — macros.
