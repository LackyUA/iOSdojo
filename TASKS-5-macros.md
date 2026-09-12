# Tasks · Part 5: Macros

`MAC` — 17 katas

---

## Setup (one time)

Before the first kata, create the package:

```bash
mkdir DojoMacros && cd DojoMacros
swift package init --type macro
```

Check that `Package.swift` has:
- a `swift-syntax` dependency (the version matching your Xcode)
- a `.macro(name: "DojoMacros", dependencies: [SwiftSyntaxMacros, SwiftCompilerPlugin])` target
- a `Dojo` library target that depends on the macro target
- a test target that depends on `SwiftSyntaxMacrosTestSupport`

**Done when:** `swift test` passes on the fresh template, and `#stringify(1 + 1)` compiles.

---

## Exploration

### `MAC-01` · Expand standard macros ⏱ 5

**Task**
1. In a file with an `@Observable` class, right-click the attribute → **Expand Macro**.
2. Do the same for `#Preview` and for `#expect(1 == 1)`.
3. In a comment, write down exactly what was generated for `@Observable`: which properties, which protocol, which registrar.

**Done when**
- [ ] You have seen the generated code for all three
- [ ] At least 3 generated elements are named for `@Observable`
- [ ] You can explain, by looking at the expansion, why `@Observable` requires `@State private var vm`

**Pitfall** "Expand Macro" is only available once the file has compiled. If the menu item is missing, build the project first.

---

### `MAC-02` · Expand `@Test` ⏱ 5

**Task**
1. Expand `@Test func example() { }` from Swift Testing.
2. Find the generated struct/variable that registers the test.
3. Answer in a comment: how does the framework discover tests without Objective-C reflection?

**Done when**
- [ ] The generated `enum`/`struct` with the test metadata is found
- [ ] You can name the registration mechanism (a section in the binary / a static property)
- [ ] Written down: a macro sees **only syntax** — it doesn't know whether the type you reference exists

**Pitfall** This is the main limitation of macros, and the reason `@Mockable` (`MAC-14`) can't generate a mock for a protocol from another module.

---

### `MAC-03` · `#warning` and `#error` ⏱ 5

**Task**
1. Add `#warning("TODO: replace with typed throws")` to your code.
2. Add `#error` to an `#if` branch that must not compile (e.g. an unsupported platform).
3. Confirm that the warning shows up in Xcode's issue list and that `#error` blocks the build.

**Done when**
- [ ] The warning with your text is visible in the Issue Navigator
- [ ] `#error` in an inactive `#if` branch does **not** break the build
- [ ] `#error` in an active branch breaks the build

**Pitfall** These are built-in macros, not preprocessor directives. They run during macro expansion, so they work with string literals but not with computed strings.

---

## Basic moves

### `MAC-04` · `#stringify` + a third element ⏱ 15

**Task**
1. In the template `#stringify`, change the return type to `(T, String, Int)`, where the third element is the number of tokens in the expression.
2. Implement the count by walking the syntax tree.
3. Check it on `#stringify(1 + 2 * 3)`.

**Done when**
- [ ] A three-element tuple is returned
- [ ] The token count is correct and verified by a test
- [ ] The declaration in `Dojo` (`@freestanding(expression)`) matches the implementation

**Pitfall** The macro declaration and implementation live in different targets. Changing the return type in one without the other gives a vague "external macro implementation type could not be found" error.

---

### `MAC-05` · `#URL` with validation ⏱ 15

**Task**
1. `@freestanding(expression) macro URL(_ string: String) -> URL`.
2. The implementation checks that the argument is a **string literal** (not a variable) and that `Foundation.URL(string:)` accepts it.
3. It generates `URL(string: "...")!` — which is now safe.

**Done when**
- [ ] `#URL("https://example.com")` compiles
- [ ] `#URL("not a url")` produces a **compile error**, not a runtime crash
- [ ] `#URL(someVariable)` produces an error explaining "a literal is required"
- [ ] The generated code contains `!`, and a comment explains why it's acceptable here

**Pitfall** The "is it a literal" check is `argument.as(StringLiteralExprSyntax.self)`. Don't forget interpolation: `"\(x)"` is also a `StringLiteralExprSyntax`, but with an expression segment.

---

### `MAC-06` · `@CaseDetection` ⏱ 15

**Task**
1. `@attached(member, names: arbitrary) macro CaseDetection()`.
2. For `enum FeedState { case idle, loading, loaded([Item]) }` it generates `var isIdle: Bool`, `var isLoading: Bool`, `var isLoaded: Bool`.
3. Handle cases with associated values via `if case .loaded = self`.

**Done when**
- [ ] All three properties are generated and work
- [ ] A case with an associated value yields a correct `is`
- [ ] Names are capitalized correctly (`idle` → `isIdle`, not `isidle`)
- [ ] A single-line `case a, b, c` is handled (it's one `EnumCaseDeclSyntax` with three elements)

**Pitfall** `case a, b, c` is the classic missed detail. Iterate over `caseDecl.elements`, not over `caseDecl`.

---

### `MAC-07` · `@AddInit` ⏱ 15

**Task**
1. `@attached(member, names: named(init)) macro AddInit()`.
2. For a class with stored properties, it generates a memberwise init.
3. Handle: `let` without a value (required parameter), `var` with a value (parameter with a default), computed property (skip).

**Done when**
- [ ] A class with 4 properties gets a correct init
- [ ] A property with a default value becomes a parameter with a default
- [ ] Computed properties and `static` properties do **not** end up in the init
- [ ] `lazy var` is handled explicitly (skipped or included — but deliberately)

**Pitfall** What tells stored from computed is an `accessorBlock` with `get`. But `didSet`/`willSet` also live in `accessorBlock`, and such a property is stored. Check specifically for `get`/`set`.

---

### `MAC-08` · `@UserDefault` ⏱ 15

**Task**
1. `@attached(accessor) macro UserDefault(_ key: String)`.
2. It turns `@UserDefault("theme") var theme: String = "light"` into a computed property with `get`/`set` over `UserDefaults`.
3. Compare the result with the property wrapper from `TYP-06`.

**Done when**
- [ ] Reading and writing work, and the value survives a "relaunch" (a new `UserDefaults` suite)
- [ ] The default value is used when the key is missing
- [ ] In a comment — a comparison with `TYP-06` on 4 criteria: in-memory type, access to `projectedValue`, compile time, error clarity
- [ ] The conclusion is written down explicitly: which one to pick in a real project

**Pitfall** An accessor macro turns a stored property into a computed one — which means the default value `= "light"` is no longer an initial value; you have to **extract it from the syntax** and insert it into `get`.

---

### `MAC-09` · Peer macro for an `async` version ⏱ 15

**Task**
1. `@attached(peer, names: overloaded) macro AddAsync()`.
2. For `func load(completion: @escaping (Result<Data, Error>) -> Void)` it generates `func load() async throws -> Data`.
3. Inside — a `withCheckedThrowingContinuation` that calls the original.

**Done when**
- [ ] Both versions of the function are available
- [ ] The async version works, proven by a test
- [ ] Parameters other than completion carry over to the async version in the same order
- [ ] A function **without** a completion parameter produces a clear macro error

**Pitfall** You have to parse `Result<Success, Failure>` in the completion syntactically to know the async version's return type. If the completion has the shape `(Data?, Error?) -> Void`, that's a different case; either support both or explicitly reject the second.

---

## SwiftSyntax

### `MAC-10` · `@SnakeCaseCodable` ⏱ 30

**Task**
1. `@attached(extension, conformances: Codable, names: named(CodingKeys)) macro SnakeCaseCodable()`.
2. It generates `extension X: Codable` and a nested `enum CodingKeys: String, CodingKey` with camelCase → snake_case mapping.
3. Support `@CodableKey("custom_name")` on an individual property as an override.

**Done when**
- [ ] `userName` maps to `"user_name"`
- [ ] `avatarURL` maps to `"avatar_url"` (not `"avatar_u_r_l"`)
- [ ] The attribute override works
- [ ] An expansion test compares the generated `CodingKeys` character by character

**Pitfall** Abbreviations (`URL`, `ID`, `HTTPStatus`) are the main difficulty of the conversion. `JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase` breaks them too; your macro has a chance to do better, but that has to be implemented deliberately.

---

### `MAC-11` · Diagnostics with Fix-It ⏱ 30

**Task**
1. Take `MAC-06` (`@CaseDetection`, which only works with enums).
2. When applied to a `struct`, emit a `Diagnostic` with `severity: .error` and a clear message.
3. Add a `FixItMessage` that offers to remove the attribute.

**Done when**
- [ ] `@CaseDetection struct Foo {}` produces an error with your text, not a plugin crash
- [ ] The error points to the right line (the node `position` is taken from)
- [ ] The Fix-It appears in Xcode and removes the attribute when applied
- [ ] A test checks the diagnostic itself via `assertMacroExpansion(diagnostics:)`

**Pitfall** Using `throw` in a macro produces a generic "macro expansion failed" error. For decent DX you need `context.diagnose(...)` and returning an empty array, not `throw`.

---

### `MAC-12` · Expansion tests ⏱ 30

**Task**
1. For any of your macros, write 3 positive tests using `assertMacroExpansion`.
2. And 2 negative ones: wrong declaration kind, wrong argument — checking `diagnostics:`.
3. Add one test with a "tricky" input: a generic, `public`, a property with an attribute.

**Done when**
- [ ] All 5+ tests pass
- [ ] The expected code in the test is formatted exactly as the macro generates it (indentation included)
- [ ] Negative tests check the diagnostic **text**, not just its presence
- [ ] Refactoring the macro implementation without changing its output doesn't break the tests

**Pitfall** `assertMacroExpansion` compares strings including indentation. Most of the time will go into matching whitespace. Print the actual result to the console and copy it from there.

---

### `MAC-13` · MemberAttribute macro ⏱ 30

**Task**
1. `@attached(memberAttribute) macro ObservableProperties()`, which attaches your own attribute to all stored properties of a type.
2. A second macro — an accessor macro that handles that attribute.
3. Apply both together and check the expansion order.

**Done when**
- [ ] The attribute appears on every stored property and on no computed one
- [ ] The accessor macro ran **after** the memberAttribute macro — proven by the result
- [ ] `static` and `lazy` properties are skipped
- [ ] An expansion test covers both levels

**Pitfall** Macro expansion order is partially unspecified. If your logic depends on another macro having already run, it's fragile. This kata is exactly about seeing that boundary.

---

### `MAC-14` · `@Mockable` ⏱ 30

**Task**
1. `@attached(peer, names: prefixed(Mock)) macro Mockable()` on a protocol.
2. It generates `final class MockX: X` with call recording and configurable return values.
3. Support: methods with parameters, `async`, `throws`, `var` with `get`/`set`.

**Done when**
- [ ] A mock for a protocol with 4 different methods is generated and compiles
- [ ] `mock.loadCallCount` and `mock.loadReceivedArguments` are available
- [ ] An `async throws` method has a configurable `loadResult: Result<Data, Error>`
- [ ] An `associatedtype` in the protocol produces a clear error (or is supported — but deliberately)

**Pitfall** This is the biggest kata in the section by amount of SwiftSyntax code. Start with a single method without parameters, and add features one at a time, with a test for each.

---

### `MAC-15` · Generics in the declaration ⏱ 30

**Task**
1. Apply `MAC-07` (`@AddInit`) to `struct Box<T: Equatable> { let value: T }`.
2. Record what was generated — and whether it was generated correctly.
3. Dig into `declaration.as(StructDeclSyntax.self)?.genericParameterClause` and `genericWhereClause`.

**Done when**
- [ ] The init for the generic type is correct
- [ ] The type's `where` clause is taken into account or explicitly ignored (with a comment)
- [ ] You can explain why the macro **doesn't know** whether `T` is actually `Equatable` at a particular use site
- [ ] At least 3 things the macro can't see are written down: types from other modules, the result of type inference, conformances

**Pitfall** A macro runs before type checking. To a macro, `let x = 5` isn't an `Int` but an `IntegerLiteralExprSyntax`. All the logic has to be built on syntax, and that fundamentally limits what can be generated at all.

---

## Judgment

### `MAC-16` · Review your own macros ⏱ 45

**Task**
1. Take three of your macros from the previous katas.
2. For each, write an alternative implementation (or sketch one) without a macro: a property wrapper, a generic, a protocol extension, script-based code generation.
3. Rate them on 4 criteria: compile time, error clarity, debuggability, clarity for a new developer.

**Done when**
- [ ] Each of the three has an explicit verdict: macro justified / not justified
- [ ] The compile-time impact is measured (at least roughly, `-Xfrontend -debug-time-function-bodies`)
- [ ] At least one macro that **wasn't worth** building is named
- [ ] Your own criterion for "when a macro is justified" is stated in 1–2 sentences

**Pitfall** Macros add a dependency on `swift-syntax` — that's tens of seconds on a clean build, plus compatibility tied to the Xcode version. For saving 5 lines of boilerplate, that's a bad deal.

---

### `MAC-17` · Production quality ⏱ 60

**Task**
1. Pick one macro and bring it to library quality.
2. Diagnostics: every incorrect application produces a clear error with a Fix-It, and not a single plugin crash.
3. Access level: the generated code is correct for `public`, `internal`, and `private` types.
4. Doc comments with examples, a README with limitations.
5. Tests: expansion, diagnostics, edge cases (generics, nested types, `@available`).

**Done when**
- [ ] Zero plugin crashes across 10 deliberately incorrect applications
- [ ] A `public struct` gets a `public init`, an `internal` one gets `internal`
- [ ] The README honestly lists what the macro does **not** support
- [ ] `swift test` passes, and coverage includes every diagnostic branch
- [ ] The macro works in a nested type (`extension Foo { @AddInit struct Bar {} }`)

**Pitfall** Access level is the most commonly missed detail. A `public struct` with an `internal init` can't be created from another module, and the error will show up in the user's code, not in the macro — so it will look like your bug in an obscure place.

---

**End of the series.** Go back to `README.md` for the chains and the practice log.
