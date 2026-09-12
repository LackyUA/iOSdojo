# Tasks · Part 1: Foundations

`FMT` · `MOD` · `TYP` · `STD` — 23 katas

> Every kata follows the format: **Task** → **Done when** → **Pitfall**.
> "Done when" is the completion criterion. If any item is unchecked, the kata doesn't count.

---

## FMT — Formatting & presentation

### `FMT-01` · Three date formats ⏱ 5

**Task**
1. Create `let date = Date(timeIntervalSince1970: 1_726_099_200)`.
2. Print it three ways using `Date.FormatStyle`: full date with the month name, ISO 8601, and relative format.
3. Repeat the output for the `uk_UA` and `en_US` locales by passing `.locale(_:)` to the style.

**Done when**
- [ ] Three different strings in the console for the same date
- [ ] The Ukrainian and English locales produce different results
- [ ] The file contains no mention of `DateFormatter`

**Pitfall** `.iso8601` is a separate `Date.ISO8601FormatStyle`, not a case of `FormatStyle`.

---

### `FMT-02` · "2 hours ago" ⏱ 5

**Task**
1. Write `func relative(_ date: Date, to reference: Date = .now, locale: Locale) -> String`.
2. Use `RelativeDateTimeFormatter` with `unitsStyle = .full` and `dateTimeStyle = .named`.
3. Check five inputs: 30 seconds, 2 hours, 1 day, 3 days, and 2 weeks ago.

**Done when**
- [ ] For "1 day ago", the Ukrainian locale yields "вчора" (yesterday), not "1 день тому"
- [ ] The function is pure: `reference` is injected rather than taken from `Date()` inside
- [ ] The formatter is created once, not on every call

**Pitfall** `RelativeDateTimeFormatter` is expensive to create — keep it in a `static let`.

---

### `FMT-03` · `Money` type ⏱ 5

**Task**
1. `struct Money { let amount: Decimal; let currency: Currency }`, where `Currency` is an enum with `rawValue: String`.
2. Add `func formatted() -> String` using `Decimal.formatted(.currency(code:))`.
3. Implement `+` so that adding different currencies is **impossible** (option: `throws`; option: a separate `SameCurrencyPair` type).

**Done when**
- [ ] `Money(amount: 0.1, ...) + Money(amount: 0.2, ...)` gives exactly `0.3`
- [ ] Trying to add UAH and USD either doesn't compile or throws an error
- [ ] The type contains no `Double` or `Float`

**Pitfall** `Decimal(0.1)` from a `Double` literal has already lost precision — use `Decimal(string:)` or integer literals.

---

## MOD — Domain models & initializers

### `MOD-01` · Four optionals → enum ⏱ 5

**Task**
1. Write out the "bad" type: `struct ScreenState { var isLoading: Bool; var items: [Item]?; var error: Error?; var isEmpty: Bool }`.
2. List in a comment 3 impossible combinations it allows (e.g. `isLoading == true` + `error != nil`).
3. Replace it with `enum ScreenState { case idle, loading, loaded([Item]), empty, failed(Error) }`.

**Done when**
- [ ] None of the three listed impossible combinations can be expressed in the new type
- [ ] A `switch` over the state compiles without `default`
- [ ] `loaded([])` and `empty` are deliberately either merged or kept separate, with the reasoning in a comment

**Pitfall** If `case loaded([Item], isLoading: Bool)` shows up after the refactor, you're back to the original problem.

---

### `MOD-02` · Two initializers ⏱ 5

**Task**
1. `struct Profile { let id: UUID; let name: String; let age: Int }` — keep the memberwise init.
2. Add `init?(json: [String: Any])` that checks types and key presence.
3. Check three inputs: valid JSON, JSON without `name`, and JSON where `age` is a `String`.

**Done when**
- [ ] The memberwise init is still available (the type is still convenient for tests)
- [ ] The three checks yield `Profile`, `nil`, `nil`
- [ ] The memberwise init has no validation at all — it lives only in the failable one

**Pitfall** If `init?` lives in the same file as the domain, that's fine for a kata, but note in a comment which layer it would move to in a real project.

---

### `MOD-03` · Private init + factory ⏱ 5

**Task**
1. `struct Discount { let percent: Int }` with a `private init`.
2. Add `static func make(percent: Int) throws -> Discount` and `enum DiscountError: Error { case outOfRange(Int) }`.
3. Check the boundaries: `-1`, `0`, `50`, `100`, `101`.

**Done when**
- [ ] `Discount(percent: 200)` doesn't compile outside the type's file
- [ ] All five checks give the expected result, and the error carries the invalid value
- [ ] Once created, a `Discount` is guaranteed valid — no further `percent` checks are needed anywhere in the code

**Pitfall** `private` in Swift is scoped to the file, not the type. For an honest check, call the init from another file.

---

### `MOD-04` · Logic inside the model ⏱ 15

**Task**
1. `struct Subscription { let startDate: Date; let period: Period; let price: Money; let cancelledAt: Date? }`.
2. Add computed properties: `isActive`, `nextBillingDate`, `daysUntilRenewal`, `totalPaid`.
3. Take the time from a parameter, not from `Date()` — make methods like `isActive(at:)` or inject `DateProviding` (see `SRV-01`).

**Done when**
- [ ] There is no `SubscriptionHelper` / `SubscriptionUtils` file
- [ ] All properties are testable without mocking the system clock
- [ ] `nextBillingDate` is correct for a monthly subscription that started on January 31

**Pitfall** Adding a month to January 31 is a classic bug. Use `Calendar.date(byAdding:to:)`, not arithmetic in seconds.

---

### `MOD-05` · Domain → UI model ⏱ 15

**Task**
1. Take an `Order` with `MOD-04`-style fields (dates, `Money`, a status enum).
2. Create `struct OrderRow: Equatable, Identifiable` with **display-ready** strings: `title`, `subtitle`, `priceText`, `statusColorName`.
3. Write `func map(_ order: Order, locale: Locale) -> OrderRow` and a test that two calls with the same input are `==`.

**Done when**
- [ ] `OrderRow` contains no `Date`, no `Decimal`, and no domain enums
- [ ] `OrderRow` conforms to `Equatable` without a custom implementation
- [ ] The mapper idempotency test is green

**Pitfall** If an `order: Order` field sneaks into `OrderRow` "just in case", the point of the separation is lost.

---

## TYP — Type safety & value semantics

### `TYP-01` · `NonEmptyString` ⏱ 5

**Task**
1. `struct NonEmptyString { let rawValue: String }` with `init?(_ value: String)`.
2. The init trims whitespace and returns `nil` if the result is empty.
3. Add `Equatable`, `Hashable`, and `CustomStringConvertible`.

**Done when**
- [ ] `NonEmptyString("   ")` → `nil`
- [ ] `rawValue` is never empty — this can't be proven by a test, only by the type's construction
- [ ] The type is used in some model's field instead of `String`

**Pitfall** `isEmpty` on a string with emoji or Unicode whitespace — check `"\u{200B}"` (zero-width space).

---

### `TYP-02` · `@Clamped` ⏱ 5

**Task**
1. `@propertyWrapper struct Clamped<Value: Comparable>` with `init(wrappedValue:_ range: ClosedRange<Value>)`.
2. `set` clamps the value to the range bounds.
3. Apply it as `@Clamped(0...100) var volume: Int = 150`.

**Done when**
- [ ] `volume` equals `100` after initialization, not `150`
- [ ] Assigning `-10` gives `0`
- [ ] The wrapper works with both `Double` and `Int` without changes

**Pitfall** Clamping must be applied in `init` too, not only in `set` — otherwise the initial value slips through invalid.

---

### `TYP-03` · Phantom type `ID<Tag>` ⏱ 15

**Task**
1. `struct ID<Tag>: Hashable, Codable { let rawValue: String }` — `Tag` is never used in the body.
2. `typealias UserID = ID<User>`, `typealias OrderID = ID<Order>`.
3. Write `func fetch(user: UserID)` and try passing an `OrderID` to it.

**Done when**
- [ ] Passing an `OrderID` instead of a `UserID` is a compile error
- [ ] `Codable` is transparent: in JSON it's just a string, not an object
- [ ] `ID<User>` can be created from a literal once you add `ExpressibleByStringLiteral`

**Pitfall** `Hashable` won't be synthesized automatically if `Tag` isn't `Hashable`. You need a conditional conformance or an explicit `extension ID: Hashable`.

---

### `TYP-04` · `@dynamicMemberLookup` over a dictionary ⏱ 15

**Task**
1. `@dynamicMemberLookup struct JSONBox` with a `storage: [String: Any]` field.
2. Implement `subscript<T>(dynamicMember key: String) -> T?` and a second variant that returns `JSONBox?` for nested objects.
3. Test it on nested JSON: `box.user?.address?.city`.

**Done when**
- [ ] A three-level nested chain reads without `as?` and without `["key"]`
- [ ] A wrong type yields `nil`, not a crash
- [ ] A comment answers: why `Codable` is better than this in a production domain

**Pitfall** Two overloaded `subscript(dynamicMember:)` with different return types often break type inference. You may need an explicit annotation at the call site.

---

### `TYP-05` · `Result<Value, Never>` and `Never` ⏱ 15

**Task**
1. Write a function that returns `Result<Int, Never>` and extract the value without `try`/`catch`.
2. Try writing `case .failure(let error)` and see what the compiler says about unreachability.
3. Write your own function with a `Never` return type and call it at the end of a `switch` branch.

**Done when**
- [ ] `get()` on `Result<Int, Never>` is called without `try`
- [ ] The `.failure` branch is either removed or flagged by the compiler as unreachable
- [ ] The `Never`-returning function is used as an expression (e.g. in a ternary or `??`)

**Pitfall** `Never` conforms to `Error` only since Swift 5.0+, and that's exactly why `Result<_, Never>` is possible at all — make sure you understand why.

---

### `TYP-06` · Typed `UserDefaults` ⏱ 15

**Task**
1. `@propertyWrapper struct Stored<Value: Codable>` with `init(wrappedValue:key:store:)`.
2. `get` decodes from `UserDefaults`, `set` encodes; a missing value yields the default.
3. Create `enum AppSettings` with three stored settings, one of which is a custom `Codable` struct.

**Done when**
- [ ] All keys are gathered in one place instead of scattered as strings across the code
- [ ] Working with a `Codable` struct (not just `Bool`/`String`) works
- [ ] `store` is injected → the test uses `UserDefaults(suiteName:)`, not `.standard`

**Pitfall** `UserDefaults` stores `Bool` natively. Wrapping a `Bool` in JSON is unnecessary overhead; consider a specialization.

---

### `TYP-07` · DIY CoW ⏱ 15

**Task**
1. `final class Box<T> { var value: T }` and `struct Wrapper<T> { private var box: Box<T> }`.
2. First, **without** CoW: mutate `wrapper2` and observe that `wrapper1` changed too. Capture this in a test.
3. In the mutating method, add an `isKnownUniquelyReferenced(&box)` check and copy if the reference isn't unique.

**Done when**
- [ ] The first test (without CoW) demonstrates "broken" value semantics
- [ ] After the fix, the same test shows the copies are independent
- [ ] A copy counter proves that a copy happens **only** on write, not on pass

**Pitfall** `isKnownUniquelyReferenced` requires `inout` and doesn't work with `let box`. It also doesn't work with classes that have Objective-C references.

---

## STD — Standard library protocols

### `STD-01` · Two descriptions for one type ⏱ 5

**Task**
1. Take a model with 5+ fields, including optionals and a date.
2. `CustomStringConvertible` → a short string for UI/info-level logs.
3. `CustomDebugStringConvertible` → all fields, including `id` and technical flags.

**Done when**
- [ ] `print(model)` and `debugPrint(model)` produce different output
- [ ] `description` doesn't contain `id`; `debugDescription` does
- [ ] `"\(model)"` in string interpolation uses `description`

**Pitfall** `String(describing:)` and `String(reflecting:)` use different protocols — check both.

---

### `STD-02` · `Comparable` via a single operator ⏱ 15

**Task**
1. `struct Employee { let department: String; let lastName: String; let hireDate: Date }`.
2. Implement **only** `static func < (lhs:rhs:)`, sorting by the three fields in order.
3. Use tuple comparison: `(a.department, a.lastName) < (b.department, b.lastName)`.

**Done when**
- [ ] `>`, `<=`, `>=`, `sorted()`, `min()`, `max()` work without extra code
- [ ] Sorting is stable across the three fields — check it on 6 elements with collisions
- [ ] The file contains exactly one comparison operator

**Pitfall** Tuple comparison works for up to 6 elements and requires all types to be `Comparable`. `Date` is; a custom enum isn't until you add it.

---

### `STD-03` · `Hashable` by `id` only ⏱ 15

**Task**
1. A model with an `id` and three mutable fields (`name`, `updatedAt`, `isFavorite`).
2. Implement `==` and `hash(into:)` using `id` only.
3. Demonstrate the consequence: put two objects with the same `id` and different `name` into a `Set` and see what remains.

**Done when**
- [ ] The `Set` contains one element, and you can tell which of the two it is
- [ ] A comment explains when this implementation is correct (a database entity) and when it's a bug (a value type)
- [ ] A `Dictionary` keyed by this model behaves predictably after a field mutation

**Pitfall** You didn't break the rule `a == b ⟹ a.hashValue == b.hashValue`. But you did break the expectation that "equal objects are interchangeable". That's the whole point of the kata.

---

### `STD-04` · `OptionSet` instead of five `Bool`s ⏱ 15

**Task**
1. `struct Permissions: OptionSet { let rawValue: Int }` with five options.
2. Add composite constants: `static let editor: Permissions = [.read, .write]`.
3. Write checks using `contains`, `isSuperset(of:)`, `subtracting`.

**Done when**
- [ ] `Permissions` serializes as a single number
- [ ] The "does the user have editor rights" check is one line without `&&`
- [ ] Adding a sixth option doesn't require changing any existing check

**Pitfall** `rawValue`s must be powers of two: `1`, `2`, `4`, `8`. `1 << 0`, `1 << 1` reads better and is harder to get wrong.

---

### `STD-05` · `RawRepresentable` for keys ⏱ 15

**Task**
1. `struct FeatureKey: RawRepresentable, Hashable { let rawValue: String }`.
2. Add static constants: `static let newOnboarding = FeatureKey(rawValue: "new_onboarding")`.
3. Replace `func isEnabled(_ key: String)` with `func isEnabled(_ key: FeatureKey)`.

**Done when**
- [ ] `isEnabled("new_onboardng")` (with a typo) no longer compiles
- [ ] Autocomplete shows all available keys after typing `.`
- [ ] A key can be added from another module without changing the type (compare with an enum)

**Pitfall** This is exactly the case where a `struct` beats an `enum`: an enum is closed to extension, while feature flags are added all the time.

---

### `STD-06` · `ExpressibleByStringLiteral` for fixtures ⏱ 15

**Task**
1. `struct Email` with validation and `init?(_ string: String)`.
2. Add `ExpressibleByStringLiteral` conformance, where the init calls `preconditionFailure` on an invalid literal.
3. Use it in a test: `let email: Email = "user@example.com"`.

**Done when**
- [ ] Tests contain no `Email("...")!`
- [ ] An invalid **literal** crashes — and a comment explains why that's acceptable for literals specifically
- [ ] Runtime data still goes through the failable init, not the literal one

**Pitfall** A literal is known at compile time, so the crash is deterministic and surfaces on the first test run. Don't do this for network data — that's a completely different risk.

---

### `STD-07` · Stable `id` ⏱ 15

**Task**
1. Make a model with `id = UUID()` as a default in the memberwise init.
2. Build a SwiftUI `List`, reload the data with the same array, and record that all rows re-rendered/"jumped".
3. Switch to an `id` that comes from the server, and repeat.

**Done when**
- [ ] The first version demonstrates the problem (proven by an animation or an `onAppear` log)
- [ ] The second version has zero re-renders for identical data
- [ ] A comment states the rule: `id` must be stable across loads, not across instances

**Pitfall** `UUID()` as a property default is generated on **every** instantiation — a silent time bomb, because the code looks correct.

---

### `STD-08` · Conditional `Collection` extension ⏱ 15

**Task**
1. `extension Collection where Element: Numeric` with `var sum: Element`.
2. Try adding `var average` — and hit the fact that `Numeric` can't divide.
3. Write two extensions: `where Element: BinaryInteger` (returns `Double`) and `where Element: FloatingPoint`.

**Done when**
- [ ] `[1, 2, 3].average` and `[1.5, 2.5].average` both work
- [ ] `["a", "b"].average` doesn't compile
- [ ] The method is available on `Array`, `Set`, and `ArraySlice` without extra code

**Pitfall** Empty collection: `average` must either return an optional or have a documented contract. Don't silently return `0`.

---

**Next:** `TASKS-2` — generics and data structures.
