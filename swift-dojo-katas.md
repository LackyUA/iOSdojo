# Swift Dojo — kata catalog

> Small moves that later come together into complex combinations.
> Every kata has a time bucket, a theme and a completion criterion.

---

## Theme legend

| Code | Theme |
|---|---|
| `FMT` | Formatting & data presentation |
| `MOD` | Domain models & initializers |
| `TYP` | Type safety, wrappers, value semantics |
| `GEN` | Generics, `any`/`some`, type erasure |
| `STD` | Standard library protocols |
| `SEQ` | Custom data structures, `Sequence`/`Collection` |
| `COD` | Codable, parsing, layer boundaries, errors |
| `SRV` | Service layer, networking, DI |
| `CNC` | Concurrency, async/await, actors |
| `STA` | State, architecture, navigation |
| `UI` | SwiftUI screens & components |
| `HIT` | Hit testing & touch delivery (UIKit) |
| `RSP` | Responder chain & first responder (UIKit) |
| `SOL` | Principles: SOLID, DRY, refactoring |
| `TST` | Testing & test doubles |
| `MAC` | Macros & SwiftSyntax |

Time buckets: **5** / **15** / **30** / **45** / **60** min.

---

# Part 1. Katas by theme

## FMT — Formatting & presentation

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| FMT-01 | Format a date three ways with `Date.FormatStyle`: `.dateTime.day().month(.wide)`, `.iso8601`, `.relative` | 5 | The reflex to reach for the modern API, not `DateFormatter` |
| FMT-02 | A "2 hours ago" helper on `RelativeDateTimeFormatter` with localization | 5 | A typical product task that often gets hand-written with bugs |
| FMT-03 | A `Money` type on `Decimal` + `FormatStyle.Currency` | 5 | Primitive obsession: money is never a `Double` or a `String` |

## MOD — Domain models & initializers

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| MOD-01 | Replace a struct with 4 optionals with an `enum` of states | 5 | "Make impossible states impossible" |
| MOD-02 | Two initializers: memberwise + failable from `[String: Any]` | 5 | The boundary between a clean domain and "dirty" data |
| MOD-03 | `private init` + `static func make(...) throws` | 5 | Control over object creation, groundwork for factories |
| MOD-04 | A `Subscription` model with computed properties instead of external helpers | 15 | Logic lives next to the data, not in "Utils" |
| MOD-05 | A `Domain → UI Model` mapper with `Equatable` | 15 | Separating "what is" from "what we show"; fewer redraws |

## TYP — Type safety & value semantics

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| TYP-01 | `NonEmptyString` via a failable init | 5 | An invariant that can't be broken after creation |
| TYP-02 | `@propertyWrapper Clamped` | 5 | A minimal step into wrappers and where they're justified |
| TYP-03 | `ID<Tag>` (phantom type): a `UserID` can't be passed in place of an `OrderID` | 15 | Type safety that catches bugs at compile time |
| TYP-04 | A `@dynamicMemberLookup` wrapper over a dictionary with typed access | 15 | When dynamism is justified and when it's just a trick |
| TYP-05 | `Result<Value, Never>` and why `Never` matters | 15 | An empty type as a design tool |
| TYP-06 | A typed wrapper over `UserDefaults` (property wrapper + generic + `Codable`) | 15 | One place for keys and defaults |
| TYP-07 | A CoW box + `isKnownUniquelyReferenced` | 15 | Why a struct with a class inside behaves strangely |

## GEN — Generics, `any`/`some`, type erasure

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| GEN-01 | A function with `some Equatable` and the same one with `any Equatable` | 5 | Feel the difference between static and dynamic dispatch firsthand |
| GEN-02 | `func firstDuplicate<T: Hashable>(in:)` | 5 | The reflex to write a generic instead of three overloads |
| GEN-03 | `Cache<Key: Hashable, Value>` with an element limit | 15 | Constrained generics with no external dependencies |
| GEN-04 | A `Validator` protocol with an `associatedtype` + `AnyValidator` | 15 | The classic case of a protocol that won't go into an array |
| GEN-05 | `AnyRepository<T>` around a protocol with an `associatedtype` | 15 | Type erasure for DI and tests |
| GEN-06 | Sorting by `KeyPath`: `sorted(by: \.name)` | 15 | Generalization instead of copy-pasted comparators |
| GEN-07 | `handle<T: Shape>(_:)` vs `handle(_: any Shape)` — where the existential forces boxing | 15 | An intuition for "when `any` costs money" |
| GEN-08 | A protocol with an `associatedtype` → struct-of-closures ("witness") | 15 | An alternative to type erasure worth having in your arsenal |
| GEN-09 | A generic with `where Self: Equatable` in a protocol extension | 15 | Conditional capabilities instead of duplicated protocols |
| GEN-10 | Return `some Collection` instead of `[Item]` | 15 | Hiding the concrete type without an existential |
| GEN-11 | A `@resultBuilder` for form validation: `Validate { NotEmpty(); Email() }` | 30 | A DSL that reads like a spec; a precursor to MAC-* |

## STD — Standard library protocols

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| STD-01 | `CustomStringConvertible` + `CustomDebugStringConvertible` for a model | 5 | Separate representations for UI and for logs |
| STD-02 | `Comparable` by implementing only `<` + sorting by several fields (tuple compare) | 15 | The protocol's minimal requirement instead of four hand-written operators |
| STD-03 | Hand-written `Hashable` (`hash(into:)`) for a type whose equality is by `id` only | 15 | The difference between identity and value equivalence |
| STD-04 | `OptionSet` for a set of permissions instead of five `Bool`s | 15 | Compact state and readable checks |
| STD-05 | A `RawRepresentable` wrapper for keys (`struct FeatureKey`) | 15 | Removes stringly-typed code |
| STD-06 | `ExpressibleByStringLiteral` for fixtures: `let email: Email = "a@b.c"` | 15 | Convenience in tests without losing validation |
| STD-07 | `Identifiable` + a deliberate choice of `id` that survives reloads | 15 | A typical cause of "jumping" SwiftUI lists |
| STD-08 | `extension Collection where Element: Numeric` with `average` | 15 | Conditional extensions instead of global functions |

## SEQ — Custom data structures & `Sequence`/`Collection`

Progression: `IteratorProtocol` → `Sequence` → `Collection` → `Bidirectional` → `RandomAccess` → `Mutable` → `RangeReplaceable`. Each next level unlocks a new batch of free algorithms from the stdlib.

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| SEQ-01 | The simplest `Sequence` via `AnyIterator` (an infinite Fibonacci sequence) | 5 | See that a `Sequence` is just "give me the next element" |
| SEQ-02 | A custom `Sequence` + `IteratorProtocol`: an iterator over "pages" of an array | 15 | So `for in` works over your own struct without converting to an array |
| SEQ-03 | `Stack<T>` conforming to `Sequence` (iterating from the top) | 15 | The first structure to get `map`/`contains`/`reduce` for free |
| SEQ-04 | `CountedSet<T>` (multiset) + `Sequence` + `ExpressibleByArrayLiteral` | 15 | Literals for your own types; when the `Dictionary` inside is an implementation detail |
| SEQ-05 | Provide `underestimatedCount` and see the difference in `Array(sequence)` | 15 | Performance as part of the protocol contract |
| SEQ-06 | `Queue<T>` on a ring buffer conforming to `Collection` | 30 | First contact with `startIndex`/`endIndex`/`index(after:)` — an index ≠ a position |
| SEQ-07 | `Deque<T>` with `BidirectionalCollection` (+ `last`, `reversed()` for free) | 30 | What bidirectionality actually adds |
| SEQ-08 | `Matrix<T>` with `RandomAccessCollection` + a 2D subscript `m[row, col]` | 30 | O(1) access and several subscripts on one type |
| SEQ-09 | `Matrix<T>` → `MutableCollection`: `m.swapAt` and `m.sort()` work | 30 | A mutating subscript and its requirements |
| SEQ-10 | `CircularBuffer<T>` with `RangeReplaceableCollection` | 45 | The hardest level: `append`, `insert`, `removeSubrange` for free |
| SEQ-11 | `LinkedList<T>` with `Collection` and a **custom `Index` type** | 45 | An index as its own abstraction, not an `Int` |
| SEQ-12 | Document and verify the index invalidation semantics for SEQ-11 | 15 | Why `Collection` is a contract, not a set of methods |
| SEQ-13 | `OrderedSet<T>`: `RandomAccessCollection` + `SetAlgebra` | 45 | Two protocols on one type without conflicts |
| SEQ-14 | `Tree<T>` with **two** separate Sequence wrappers: `.dfs` and `.bfs` | 30 | Traversal order is a type, not a function parameter |
| SEQ-15 | A `Trie` as a `Sequence` of words + prefix search returning `some Sequence` | 45 | Lazy iteration without materializing an array |
| SEQ-16 | `PriorityQueue<T>` (heap) — and justify why it is **not** a `Collection` | 30 | The most important kata of the section: not every collection is a `Collection` |
| SEQ-17 | `LazyChunkedSequence` via `LazySequenceProtocol` + `chunks(of:)` on a `LazyCollection` | 30 | How to plug into the stdlib's `.lazy` chain |
| SEQ-18 | `Zip3Sequence` (a custom generic sequence over three sources) | 30 | A generic struct with three iterators — a SEQ + GEN combination |
| SEQ-19 | A custom `AsyncSequence` + `AsyncIteratorProtocol`: a paginated feed | 45 | `for await` over your own source; a SEQ ↔ CNC bridge |
| SEQ-20 | `WeakArray<T: AnyObject>` with `Collection` (elements are `T?`) | 30 | A collection whose contents change on their own — the limits of value semantics |
| SEQ-21 | Add CoW storage to SEQ-06 or SEQ-08 and measure the copies | 45 | Your own structure with value semantics, like `Array` |

## COD — Codable, parsing, errors

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| COD-01 | `Codable` with `CodingKeys`, a nested container and a custom `init(from:)` | 15 | Real APIs never have a flat structure |
| COD-02 | A `DTO → Domain` mapper + a test for data loss | 15 | The layer boundary is where abstractions leak most often |
| COD-03 | `enum AppError` + mapping `URLError`/`DecodingError` into it | 15 | The UI should never see infrastructure errors |
| COD-04 | A `Decodable` enum with a `.unknown` fallback | 15 | Protects the client from crashing after an API release |
| COD-05 | Lossy array decoding: one broken element doesn't break the list | 15 | Real parsing resilience |
| COD-06 | Typed throws: `func load() throws(LoadError)` + comparison with `any Error` | 30 | A new language feature worth having at hand |

## SRV — Service layer, networking, DI

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| SRV-01 | A `DateProviding` protocol + injection instead of `Date()` | 15 | Makes time testable; DIP in the smallest example |
| SRV-02 | Building URLs with `URLComponents` and typed query parameters | 15 | Removes string concatenation |
| SRV-03 | An `HTTPClient` protocol + a `URLSession` implementation + `MockHTTPClient` | 30 | The skeleton of any service layer |
| SRV-04 | `protocol APIRequest { associatedtype Response: Decodable }` + a generic `send(_:)` | 30 | One call instead of N methods in a service |
| SRV-05 | A `UserService` with an injected client and mapper + 3 unit tests | 30 | Checks that DIP really delivers testability |
| SRV-06 | A minimal DI container: registering factories + resolving | 30 | Understanding what frameworks do under the hood |
| SRV-07 | A middleware chain for `HTTPClient`: auth → logging → retry | 30 | Composition instead of subclassing clients |
| SRV-08 | A `RetryPolicy` with exponential backoff + jitter and determinism tests | 30 | Moves the policy out of the service |
| SRV-09 | A generic `Store<T: Codable>` over files/Keychain behind one protocol | 30 | Persistence without tying yourself to a mechanism |
| SRV-10 | An `AnalyticsService` with enum events instead of `track("name", params)` | 30 | The compiler instead of code review |
| SRV-11 | Move a singleton to an injected dependency, keeping `static let shared` as a shim | 30 | A realistic migration, not "I rewrote everything" |

## CNC — Concurrency

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| CNC-01 | Refactor a `Result`-based function into `async throws` | 15 | A migration move you'll make many times |
| CNC-02 | Fix every `Sendable` warning on a small type with mutable state | 15 | Preparing for strict concurrency |
| CNC-03 | `Task.checkCancellation()` in a processing loop | 15 | So a task actually stops instead of "pretending" |
| CNC-04 | A `Clock` abstraction instead of `Task.sleep` + a test with no real waiting | 15 | Timing tests without flakiness |
| CNC-05 | An actor cache with TTL | 30 | Concurrency without locks, isolated state |
| CNC-06 | An `AsyncStream` wrapper over a callback API | 30 | A bridge between old and new code |
| CNC-07 | Deduplicating concurrent requests in an actor: one call for N callers | 30 | The typical image/data loader |
| CNC-08 | `withThrowingTaskGroup`: three parallel requests with a "partial success" policy | 30 | Deciding what to do when one of the three fails |

## STA — State, architecture, navigation

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| STA-01 | A pure pagination function `nextPage(from:)` + edge-case tests | 30 | Logic without UIKit/SwiftUI — perfect for a playground |
| STA-02 | Pagination as an enum state machine + a transition table in tests | 30 | No `isLoading` + `hasMore` + `error` at the same time |
| STA-03 | A pure `reduce(state, action) -> state` for a small feature + UI-free tests | 30 | The essence of any unidirectional data flow |
| STA-04 | Command pattern with undo/redo for a task list | 30 | Encapsulating an action as an object |
| STA-05 | A repository that emits an `AsyncStream` of changes, and two observers | 30 | Push instead of pull, keeping screens in sync |
| STA-06 | Feature flags: Strategy (remote/local/override) behind one protocol | 30 | Swapping behavior at runtime without ifs |
| STA-07 | Two data sources (remote + cache) behind one protocol via Strategy | 45 | Swapping behavior without ifs in the ViewModel |
| STA-08 | A feature with abstracted navigation (router as a protocol) | 45 | The screen doesn't know where it leads |
| STA-09 | End-to-end search: debounce, cancellation, domain, mapper, VM, tests | 60 | Combines almost all previous moves into one combination |
| STA-10 | Master → Detail with a shared repository and an optimistic update | 60 | Syncing state between screens |
| STA-11 | An offline-first flow: write locally → sync → conflict | 60 | An architectural decision in miniature |

## UI — SwiftUI

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| UI-01 | A login screen: `@Observable` VM, validation, disabled button state | 30 | A simple screen with a clear separation of responsibilities |
| UI-02 | A custom `EnvironmentKey` for injecting a service + a preview with a fake | 30 | DI without a container |
| UI-03 | `@Observable` VM + `@MainActor`, heavy work off the main thread | 30 | The boundary between UI and computation |
| UI-04 | A list screen with every state: loading / empty / error / content + retry | 45 | The states that get forgotten 80% of the time |
| UI-05 | A design system component (`Badge`/`Card`) with `some View`, `@ViewBuilder`, style variants | 45 | Reusable UI primitives instead of copy-paste |

## HIT — Hit testing & touch delivery

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| HIT-01 | Trace `hitTest`/`point(inside:)` through a three-level hierarchy and read the call order | 5 | The algorithm behind every tap, seen once instead of guessed |
| HIT-02 | The four rules that stop a hit test: hidden, alpha, interaction, bounds | 5 | "Visible but untappable" stops being a mystery |
| HIT-03 | Reimplement `hitTest(_:with:)` from scratch and diff it against UIKit's over a grid of points | 15 | You know the algorithm only once you can write it |
| HIT-04 | `ExpandedTouchButton`: tap-area insets and a 44×44 minimum via `point(inside:)` | 15 | The most common real fix — a tap target that's too small |
| HIT-05 | A container that catches touches on a subview hanging outside its bounds | 15 | Badges and close buttons that overhang and stop responding |
| HIT-06 | `PassthroughView`: an overlay tappable only where its subviews are | 15 | Full-screen overlays that don't block the screen underneath |
| HIT-07 | A pass-through `UIWindow` for toasts over the whole app | 30 | The production shape: an overlay window that stays out of the way |
| HIT-08 | From the hit-test view into the chain: `touchesBegan`, `super`, and a recognizer above | 15 | Where hit testing ends and the responder chain begins |

## RSP — Responder chain & first responder

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| RSP-01 | `responderChain` via `sequence(first:next:)`, read from three different places | 5 | The chain is not the view hierarchy — see exactly where they part |
| RSP-02 | Find the current first responder with the nil-target `sendAction` trick | 5 | One line that explains how the whole chain dispatches |
| RSP-03 | A custom view with `UIKeyInput`, `becomeFirstResponder` and an `inputAccessoryView` | 15 | First responder from the other side: being one, not finding one |
| RSP-04 | An action sent up the chain, plus a veto in `canPerformAction(_:withSender:)` | 15 | Events without delegates — and the price you pay for them |
| RSP-05 | An edit menu on a custom view, filtered through `canPerformAction(_:withSender:)` | 15 | `UIEditMenuInteraction`, and why menus need a first responder |
| RSP-06 | Replace a three-level closure hand-off with routing over the responder chain | 30 | Architecture on the chain — including why the obvious version doesn't dispatch |

## SOL — Principles & refactoring

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| SOL-01 | Split a 15-line function with three `if`s into two pure functions | 5 | SRP at the smallest scale |
| SOL-02 | `switch`/`as?` on type → polymorphism | 15 | Eliminating type checks, the classic OCP move |
| SOL-03 | Split a "fat" protocol into two small ones for specific clients | 15 | ISP firsthand |
| SOL-04 | Find a DRY violation that should **not** be fixed, and justify it | 15 | Training judgment, not a mechanical rule |
| SOL-05 | Refactor an 80-line "God object" into three types | 30 | SRP at a realistic size, not a toy one |
| SOL-06 | Three nearly identical functions → one generic + config | 30 | DRY and the question "where is the line past which DRY hurts" |
| SOL-07 | Composable form validation (`&&`, `\|\|`) without changing existing types | 45 | OCP: a new rule is added, old code is untouched |
| SOL-08 | Find an LSP violation in your own protocol (an implementation with `fatalError`) | 45 | Seeing when a protocol/inheritance was the wrong choice |
| SOL-09 | Legacy kata: rewrite a "bad" file to SOLID, covering it with tests first | 60 | Refactoring under the protection of tests, not rewriting from scratch |

## TST — Testing

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| TST-01 | Parameterized Swift Testing tests `@Test(arguments:)` for a validator | 15 | A table of cases instead of five copies of one test |
| TST-02 | A mapper test with a JSON fixture from a file (not from a string in code) | 15 | Fixtures as data, not as code |
| TST-03 | Three test doubles for one protocol: stub, spy, mock — and when to use each | 30 | Breaks the habit of "mocking everything" |

Related: SRV-01, SRV-05, SRV-08, CNC-04, STA-02, STA-03, MAC-12.

## MAC — Macros & SwiftSyntax

> ⚠️ Macros don't compile in a regular `.playground`. You need a SwiftPM package with a `CompilerPlugin` target. Create `dojo-macros` once with a skeleton (`Dojo`, `DojoMacros`, `DojoTests`) and do all katas there.

### Exploration

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| MAC-01 | Take `@Observable`, `#Preview`, `#expect` and run "Expand Macro" in Xcode | 5 | See that the magic is just generated code |
| MAC-02 | Expand `@Test` and find where the runtime registration happens | 5 | A macro doesn't see types — only syntax |
| MAC-03 | `#warning`/`#error` as freestanding macros in your own code | 5 | The simplest contact with compile time |

### Basic moves

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| MAC-04 | The template `#stringify`: make it return a third element | 15 | Your first edit of an `ExpressionMacro` |
| MAC-05 | `#URL("https://...")` with compile-time literal validation | 15 | Removes `URL(string:)!` from the codebase |
| MAC-06 | `@CaseDetection`: a member macro generating `var isLoading: Bool` for each case | 15 | Generating boilerplate nobody wants to write by hand |
| MAC-07 | `@AddInit`: a memberwise initializer for a class | 15 | Making up for what the language lacks |
| MAC-08 | An accessor macro `@UserDefault("key")` → computed property | 15 | Compare with TYP-06 and decide which is better |
| MAC-09 | A peer macro that adds an `async` version to a completion-based function | 15 | Automating an API migration |

### SwiftSyntax

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| MAC-10 | An extension macro: `Codable` conformance with automatic snake_case → camelCase mapping | 30 | A real replacement for hand-written `CodingKeys` |
| MAC-11 | A diagnostic with a `FixItMessage` when the macro is applied to something other than an enum | 30 | A macro as part of DX, not just a generator |
| MAC-12 | `assertMacroExpansion`: 3 positive + 2 negative cases | 30 | A macro without expansion tests can't be refactored |
| MAC-13 | A MemberAttribute macro that attaches an attribute to all stored properties | 30 | Understanding the order in which macros are applied |
| MAC-14 | `@Mockable`: generating a spy implementation of a protocol | 30 | What people usually pull in Sourcery/Cuckoo for |
| MAC-15 | Parsing `declaration.as(StructDeclSyntax.self)` on a generic type | 30 | The limits of what a macro "sees" |

### Judgment

| ID | Kata | ⏱ | Why |
|---|---|---|---|
| MAC-16 | For three of your own macros, answer: would a property wrapper, a generic or an extension solve this? | 45 | The most important kata of the section — a macro is expensive in compile time and debugging |
| MAC-17 | Take one macro to production quality: diagnostics, tests, docs, `public`/`internal` | 60 | The difference between a demo and a library |

---

# Part 2. Time index

## 5 min — single moves (20)
`FMT-01` `FMT-02` `FMT-03` `MOD-01` `MOD-02` `MOD-03` `TYP-01` `TYP-02` `GEN-01` `GEN-02` `STD-01` `SEQ-01` `HIT-01` `HIT-02` `RSP-01` `RSP-02` `SOL-01` `MAC-01` `MAC-02` `MAC-03`

## 15 min — short links (57)
`MOD-04` `MOD-05` `TYP-03` `TYP-04` `TYP-05` `TYP-06` `TYP-07`
`GEN-03` `GEN-04` `GEN-05` `GEN-06` `GEN-07` `GEN-08` `GEN-09` `GEN-10`
`STD-02` `STD-03` `STD-04` `STD-05` `STD-06` `STD-07` `STD-08`
`SEQ-02` `SEQ-03` `SEQ-04` `SEQ-05` `SEQ-12`
`COD-01` `COD-02` `COD-03` `COD-04` `COD-05`
`SRV-01` `SRV-02`
`CNC-01` `CNC-02` `CNC-03` `CNC-04`
`HIT-03` `HIT-04` `HIT-05` `HIT-06` `HIT-08`
`RSP-03` `RSP-04` `RSP-05`
`SOL-02` `SOL-03` `SOL-04`
`TST-01` `TST-02`
`MAC-04` `MAC-05` `MAC-06` `MAC-07` `MAC-08` `MAC-09`

## 30 min — combinations (44)
`GEN-11` `SEQ-06` `SEQ-07` `SEQ-08` `SEQ-09` `SEQ-14` `SEQ-16` `SEQ-17` `SEQ-18` `SEQ-20`
`COD-06`
`SRV-03` `SRV-04` `SRV-05` `SRV-06` `SRV-07` `SRV-08` `SRV-09` `SRV-10` `SRV-11`
`CNC-05` `CNC-06` `CNC-07` `CNC-08`
`STA-01` `STA-02` `STA-03` `STA-04` `STA-05` `STA-06`
`UI-01` `UI-02` `UI-03`
`HIT-07` `RSP-06`
`SOL-05` `SOL-06`
`TST-03`
`MAC-10` `MAC-11` `MAC-12` `MAC-13` `MAC-14` `MAC-15`

## 45 min — sections (13)
`SEQ-10` `SEQ-11` `SEQ-13` `SEQ-15` `SEQ-19` `SEQ-21`
`STA-07` `STA-08`
`UI-04` `UI-05`
`SOL-07` `SOL-08`
`MAC-16`

## 60 min — full form (5)
`STA-09` `STA-10` `STA-11` `SOL-09` `MAC-17`

---

# Part 3. Dojo rules

1. **A completion criterion is mandatory.** It compiles / the test is green / the screen shows 4 states. Otherwise 15 minutes turn into 90.
2. **The timer is part of the kata.** Ran out of time — note where you got stuck and don't continue. That is the diagnosis.
3. **Repeat after a week.** Solve the same kata again without looking at your previous solution, and compare.
4. **Combinations.** Once a week, take 3–4 katas from different themes and stitch them into one (e.g. `SEQ-06` + `GEN-03` + `TST-03`).
5. **Don't start with the 60-minute ones.** They only assemble what is already automatic.

## Recommended chains

| Chain | Katas |
|---|---|
| Type erasure | `GEN-01` → `GEN-07` → `GEN-04` → `GEN-05` → `GEN-08` |
| From iterator to collection | `SEQ-01` → `SEQ-02` → `SEQ-03` → `SEQ-06` → `SEQ-07` → `SEQ-08` → `SEQ-10` → `SEQ-11` |
| Service layer from scratch | `SRV-02` → `SRV-03` → `SRV-04` → `SRV-07` → `SRV-08` → `SRV-05` |
| Painless state | `MOD-01` → `STA-02` → `STA-03` → `UI-04` |
| Metaprogramming | `TYP-02` → `TYP-06` → `GEN-11` → `MAC-08` → `MAC-16` |
| Swift 6 concurrency | `CNC-01` → `CNC-02` → `CNC-03` → `CNC-05` → `CNC-08` → `SEQ-19` |
| A touch, from pixel to handler | `HIT-01` → `HIT-02` → `HIT-03` → `HIT-04` → `HIT-06` → `HIT-08` → `RSP-01` → `RSP-04` |
| Overlays that behave | `HIT-06` → `HIT-05` → `HIT-07` → `RSP-06` |

## Log template

```
| ID | Attempt 1 | Attempt 2 | Attempt 3 | Difficulty (1-5) | Where I got stuck |
|----|-----------|-----------|-----------|------------------|-------------------|
| SEQ-06 | 2026-09-12 ✅ 28min |  |  | 4 | index(after:) on wrap-around |
```
