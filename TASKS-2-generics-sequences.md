# Tasks · Part 2: Generics & data structures

`GEN` · `SEQ` — 32 katas

---

## GEN — Generics, `any`/`some`, type erasure

### `GEN-01` · `some` vs `any`, hands-on ⏱ 5

**Task**
1. Write `func areEqual(_ a: some Equatable, _ b: some Equatable) -> Bool` and see that it doesn't compile.
2. Fix it to `func areEqual<T: Equatable>(_ a: T, _ b: T) -> Bool`.
3. Write a version with `any Equatable` and try to compare the two values inside.

**Done when**
- [ ] You can explain in one sentence why `some, some` means two different types
- [ ] The `any` version fails to compile on `a == b`, and you know why
- [ ] Written in a comment: `some` = "some specific type, and the compiler knows which", `any` = "any type, erased"

**Pitfall** `some` in parameter position is syntactic sugar for a generic. Two `some` in a signature = two independent type parameters.

---

### `GEN-02` · `firstDuplicate` ⏱ 5

**Task**
1. `func firstDuplicate<T: Hashable>(in sequence: some Sequence<T>) -> T?`.
2. Implement it in a single pass using a `Set`.
3. Test it on `[Int]`, `[String]`, `Set<Int>` and your own `Hashable` type.

**Done when**
- [ ] One function works for all four inputs
- [ ] Complexity is O(n), not O(n²)
- [ ] An empty sequence and a sequence without duplicates both return `nil`

**Pitfall** A `Set<Int>` can't contain duplicates — a good check that your function doesn't crash on "pointless" input.

---

### `GEN-03` · `Cache<Key, Value>` ⏱ 15

**Task**
1. `final class Cache<Key: Hashable, Value>` with `limit: Int`.
2. `subscript(key: Key) -> Value?` for both reading and writing.
3. When the limit is exceeded, evict the oldest element (FIFO is enough, LRU is a bonus).

**Done when**
- [ ] After 101 inserts with `limit = 100` the size is exactly 100
- [ ] The evicted element is exactly the one you expect — proven by a test
- [ ] The type works with `Key = String` and `Key = ID<User>` from `TYP-03` without changes

**Pitfall** Eviction order needs a second structure (an array of keys or a linked list). `Dictionary` doesn't preserve order.

---

### `GEN-04` · `AnyValidator` ⏱ 15

**Task**
1. `protocol Validator { associatedtype Input; func validate(_ input: Input) throws }`.
2. Make three implementations (`NotEmpty`, `MinLength`, `EmailFormat`) and try to put them in a `[Validator]` — record the compiler error.
3. Write a `struct AnyValidator<Input>: Validator` that wraps a closure, and build the array.

**Done when**
- [ ] The compiler error text is written down in a comment
- [ ] `[AnyValidator<String>]` compiles and can be iterated in a loop
- [ ] `init<V: Validator>(_ validator: V) where V.Input == Input` is added

**Pitfall** Erasure keeps `Input` as a generic parameter, because otherwise `validate` can't be called type-safely. Only the concrete validator type is erased.

---

### `GEN-05` · `AnyRepository<T>` ⏱ 15

**Task**
1. `protocol Repository { associatedtype Model; func all() async throws -> [Model]; func save(_ model: Model) async throws }`.
2. Implement `InMemoryRepository<Item>` and `AnyRepository<Model>`.
3. Add a `let repo: AnyRepository<Item>` property to a service and inject a fake in a test.

**Done when**
- [ ] The service doesn't know the concrete repository type
- [ ] The test injects the fake without any change to the service code
- [ ] `AnyRepository` forwards errors and `async` transparently

**Pitfall** Closures that store `async throws` need the exact type: `@Sendable () async throws -> [Model]`. Without `@Sendable` you get a warning in Swift 6.

---

### `GEN-06` · Sorting by `KeyPath` ⏱ 15

**Task**
1. `extension Sequence { func sorted<V: Comparable>(by keyPath: KeyPath<Element, V>) -> [Element] }`.
2. Add an overload with an `order: SortOrder` parameter.
3. Bonus: `sorted(by: \.department, then: \.lastName)`.

**Done when**
- [ ] `people.sorted(by: \.age)` works
- [ ] No call site passes a `{ $0.age < $1.age }` closure
- [ ] The two-key variant sorts stably

**Pitfall** The standard library already has `sorted(using:)` with `SortComparator` (iOS 15+). Compare your API with it and say in a comment whether writing your own was worth it.

---

### `GEN-07` · The cost of an existential ⏱ 15

**Task**
1. `protocol Shape { var area: Double { get } }` and three conforming structs.
2. Write `func totalArea<T: Shape>(_ shapes: [T]) -> Double` and `func totalArea(_ shapes: [any Shape]) -> Double`.
3. Run both on 100,000 elements and compare the timings.

**Done when**
- [ ] Both functions return the same result
- [ ] The measured time difference is recorded in a comment
- [ ] You can explain why the generic version doesn't accept an array of **different** shapes

**Pitfall** Measure in the Release configuration. In Debug the difference is drowned out by the lack of optimizations.

---

### `GEN-08` · A witness instead of a protocol ⏱ 15

**Task**
1. Take `Validator` from `GEN-04`.
2. Replace the protocol with `struct ValidatorWitness<Input> { let validate: (Input) throws -> Void }`.
3. Add static factories: `static var notEmpty: ValidatorWitness<String>`, `static func minLength(_ n: Int) -> ValidatorWitness<String>`.

**Done when**
- [ ] No protocol and no erasure wrapper — just one struct
- [ ] Combining two validators is a function that returns a third
- [ ] A comment compares this with `GEN-04`: what you lost, what you gained

**Pitfall** You lose: protocol extensions, default implementations, `where` constraints. You gain: no erasure at all, composition as a plain function.

---

### `GEN-09` · `where Self: Equatable` ⏱ 15

**Task**
1. `protocol Identifiable2 { var id: String { get } }` (your own, so it doesn't clash with the stdlib).
2. Add `extension Identifiable2 where Self: Equatable { func isSame(as other: Self) -> Bool }`.
3. Make two types, one `Equatable` and one not, and check that only the first has the method.

**Done when**
- [ ] The method is unavailable on the type without `Equatable` — a compile error
- [ ] No second `EquatableIdentifiable` protocol was created
- [ ] Autocomplete shows a different set of methods on the two types

**Pitfall** `where Self: X` in an extension is not the same as `protocol A: X`. The latter forces **every** conformer to conform to `X`.

---

### `GEN-10` · Returning `some Collection` ⏱ 15

**Task**
1. A function `func activeItems(in items: [Item]) -> [Item]` using `.filter`.
2. Change the return type to `some Collection<Item>` and return `items.lazy.filter { ... }`.
3. At the call site, try `result.append(...)` and `result[0]`.

**Done when**
- [ ] The caller doesn't know there's a `LazyFilterCollection` inside
- [ ] `append` doesn't compile, indexing works
- [ ] Switching the implementation to `Array` doesn't break any call site

**Pitfall** `some Collection<Item>` pins **one** concrete type for all returns. Two `if` branches returning different collection types won't compile.

---

### `GEN-11` · `@resultBuilder` for validation ⏱ 30

**Task**
1. `@resultBuilder struct ValidationBuilder` with `buildBlock`, `buildOptional`, `buildEither`.
2. API: `let rules = Validate { NotEmpty(); MinLength(8); Contains(.digit) }`.
3. Add a condition inside the builder: `if requiresSymbol { Contains(.symbol) }`.

**Done when**
- [ ] A block with three rules compiles and runs
- [ ] `if` inside the block works (that's `buildOptional`)
- [ ] `if/else` with different rules works (that's `buildEither`)

**Pitfall** Without `buildOptional`, a bare `if` in the builder produces a vague compile error. Add the methods one at a time and see which syntax each one "unlocks".

---

## SEQ — Data structures

> Progression: each next protocol gives you a new batch of algorithms for free. Don't move to the next level until the previous one works.

### `SEQ-01` · `Sequence` via `AnyIterator` ⏱ 5

**Task**
1. `func fibonacci() -> some Sequence<Int>` built on `AnyIterator`.
2. The sequence is infinite — state lives in the closure.
3. Use `.prefix(10)` and `.first(where: { $0 > 1000 })`.

**Done when**
- [ ] `Array(fibonacci().prefix(10))` yields the correct 10 numbers
- [ ] `for in` without `prefix` hangs — and you understand why that's expected
- [ ] `.first(where:)` finishes without computing the whole sequence

**Pitfall** `.map` on an infinite sequence hangs, because `Sequence.map` is eager. `.lazy.map` isn't.

---

### `SEQ-02` · A page iterator ⏱ 15

**Task**
1. `struct PagedSequence<Element>: Sequence` with fields `elements: [Element]`, `pageSize: Int`.
2. `struct PagedIterator<Element>: IteratorProtocol` with `Element == [Element]` — i.e. it yields arrays.
3. Test with 10 elements and `pageSize = 3`: there must be 4 pages, the last one with a single element.

**Done when**
- [ ] `for page in PagedSequence(...)` yields 4 arrays
- [ ] A zero or negative `pageSize` is handled explicitly (a crash or a precondition — but deliberately)
- [ ] A second pass over the same sequence gives the same result

**Pitfall** `Sequence` doesn't promise repeatable iteration — but your implementation must pick a behavior and document it. If the iterator mutates the storage, the second pass yields nothing.

---

### `SEQ-03` · `Stack<T>: Sequence` ⏱ 15

**Task**
1. `struct Stack<Element>` with `push`, `pop`, `peek`, `isEmpty`, backed by an array.
2. Add `Sequence` conformance, iterating **from the top** to the bottom.
3. Check that `map`, `contains`, `reduce`, `first` came for free.

**Done when**
- [ ] `Array(stack)` yields elements starting from the last one pushed
- [ ] `stack.contains(x)` works without your own implementation
- [ ] Iteration does **not** destroy the stack — after `for in` all elements are still there

**Pitfall** The simplest path is `makeIterator() { storage.reversed().makeIterator() }`. But make sure `reversed()` on `Array` is a `ReversedCollection` with no copying, not a new array.

---

### `SEQ-04` · `CountedSet` + literal ⏱ 15

**Task**
1. `struct CountedSet<Element: Hashable>` with `[Element: Int]` storage.
2. API: `insert`, `remove`, `count(of:)`, `subscript(element) -> Int`.
3. Add `Sequence` (yields each element as many times as it occurs) and `ExpressibleByArrayLiteral`.

**Done when**
- [ ] `let bag: CountedSet = ["a", "a", "b"]` compiles
- [ ] `bag.count(of: "a") == 2`
- [ ] `Array(bag).count == 3`, and the order is documented (it's nondeterministic!)

**Pitfall** `Dictionary` iteration order is nondeterministic across runs. If a test compares the array directly, it will be flaky. Compare as a `CountedSet` or sort first.

---

### `SEQ-05` · `underestimatedCount` ⏱ 15

**Task**
1. Take `SEQ-02` or `SEQ-03` and add logging to `makeIterator` and `next`.
2. Run `Array(sequence)` and count how many times the storage was reallocated (via a `reserveCapacity` log or simply by counting calls).
3. Implement `var underestimatedCount: Int` and measure again.

**Done when**
- [ ] The number of reallocations before and after is recorded as numbers
- [ ] `underestimatedCount` is never greater than the real count
- [ ] A comment lists what else uses this value (`Array.init`, `reserveCapacity`, `flatMap`)

**Pitfall** If `underestimatedCount` overstates, you get either a crash or silently wrong behavior in the stdlib. The contract: "no more than the actual count".

---

### `SEQ-06` · `Queue` on a ring buffer + `Collection` ⏱ 30

**Task**
1. `struct Queue<Element>` with fixed-size `[Element?]` storage, `head`, `tail`, `count`.
2. `enqueue`/`dequeue` in O(1) with index wrap-around.
3. `Collection` conformance: `startIndex`, `endIndex`, `index(after:)`, `subscript(position:)`.

**Done when**
- [ ] `startIndex` is always `0`, not `head` — and you can explain why that's more correct
- [ ] `Array(queue)` yields elements in queue order, even when the buffer has "wrapped"
- [ ] `queue.first`, `queue.count`, `queue.map` work without your own implementations
- [ ] Test: fill it, dequeue half, enqueue more — the order is correct

**Pitfall** The main mistake is making `Index == head`. Then `endIndex < startIndex` after wrap-around, and the whole stdlib breaks. A `Collection` index is a logical position from the start, not a physical one in the buffer.

---

### `SEQ-07` · `Deque` + `BidirectionalCollection` ⏱ 30

**Task**
1. Extend `SEQ-06` into a `Deque` with `prepend`/`removeLast`.
2. Add `BidirectionalCollection`: implement `index(before:)`.
3. Check what came for free.

**Done when**
- [ ] `deque.last` works in O(1), not via a full pass
- [ ] `deque.reversed()` returns a `ReversedCollection`, not an array
- [ ] `deque.suffix(3)`, `deque.dropLast()`, `deque.lastIndex(of:)` work
- [ ] A comment lists at least 5 methods that this particular protocol added

**Pitfall** Before `BidirectionalCollection`, `last` was O(n). Check this on `SEQ-06` to see the difference with your own eyes.

---

### `SEQ-08` · `Matrix` + `RandomAccessCollection` ⏱ 30

**Task**
1. `struct Matrix<Element>` with `rows`, `columns` and flat `[Element]` storage.
2. `subscript(row: Int, column: Int) -> Element` with bounds checking.
3. `RandomAccessCollection` conformance with `Index == Int`, iterating in row-major order.

**Done when**
- [ ] Two subscripts coexist: `m[1, 2]` and `m[5]` (by `Index`)
- [ ] `m.count == rows * columns`
- [ ] `m.distance(from:to:)` and `m.index(_:offsetBy:)` are O(1)
- [ ] `m.dropFirst(1000)` on a 1000×1000 matrix is instant

**Pitfall** `RandomAccessCollection` is a **complexity promise**, not a set of methods. If your `index(_:offsetBy:)` is O(n), you lied to the compiler and will get silent performance problems in stdlib algorithms.

---

### `SEQ-09` · `Matrix` → `MutableCollection` ⏱ 30

**Task**
1. Make `subscript(position: Index)` with `get` **and** `set`.
2. Add `MutableCollection` conformance.
3. Check: `m.swapAt(0, 5)`, `m.sort()`, `m[2, 3] = x`, `m.reverse()`.

**Done when**
- [ ] `m.sort()` works (requires `Element: Comparable`)
- [ ] `swapAt` doesn't copy the whole storage
- [ ] Mutating via the 2D subscript and via the `Index` subscript gives the same result
- [ ] `partition(by:)` and `shuffle()` are available

**Pitfall** `MutableCollection` forbids changing `count` or the index structure — only values. If your `set` can change the size, the conformance is incorrect.

---

### `SEQ-10` · `CircularBuffer` + `RangeReplaceableCollection` ⏱ 45

**Task**
1. Take `SEQ-06` and add an (empty) `init()` — the protocol requires it.
2. Implement `replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newElements: C)`.
3. `RangeReplaceableCollection` conformance.

**Done when**
- [ ] `append`, `insert(at:)`, `remove(at:)`, `removeSubrange`, `+=` work — all from a single method
- [ ] `buffer.removeAll(where: { ... })` works
- [ ] `init(repeating:count:)` is available
- [ ] A test covers 5 `replaceSubrange` cases: insert at the start, middle, end, removal, replacement with a longer array

**Pitfall** This is the hardest conformance in the section. `replaceSubrange` must correctly handle `newElements` being longer than `subrange` — i.e. the buffer growing. Start with a simple implementation via an intermediate array, then optimize.

---

### `SEQ-11` · `LinkedList` with a custom `Index` ⏱ 45

**Task**
1. `final class Node<Element>` and `struct LinkedList<Element>` with `head`/`tail`.
2. `struct Index: Comparable` holding a reference to a node — **not** an `Int`.
3. `Collection` conformance: `startIndex`, `endIndex`, `index(after:)`, `subscript`.

**Done when**
- [ ] `Index` compares correctly (`<` works), even though it isn't a number
- [ ] `endIndex` represents the "past the last" position, with or without a sentinel node — but deliberately
- [ ] `list.firstIndex(of: x)` and `list[index]` work
- [ ] `list.count` is O(n), and that's documented

**Pitfall** Implementing `Comparable` for an `Index` without an `Int` position is hard. The simplest honest option is to keep both the node and its ordinal position in `Index`. Compare by position, access by node.

---

### `SEQ-12` · Index invalidation ⏱ 15

**Task**
1. Take `SEQ-11`. Get `let i = list.index(after: list.startIndex)`.
2. Remove an element before `i`, then try `list[i]`.
3. Document in a doc comment above the type which operations invalidate indices.

**Done when**
- [ ] The post-invalidation behavior is reproduced in a test (a crash, a wrong value, or correct behavior)
- [ ] The doc comment states the contract as explicitly as `Array` does in the stdlib
- [ ] Compared with `Array`: indices get invalidated there too, but more "quietly"

**Pitfall** This kata isn't about code, it's about the contract. A `Collection` is a set of promises about complexity and index validity. Break a promise silently and you've created a bug someone will find six months later.

---

### `SEQ-13` · `OrderedSet` ⏱ 45

**Task**
1. `struct OrderedSet<Element: Hashable>` with an `[Element]` + `Set<Element>` inside.
2. `RandomAccessCollection` conformance (insertion order).
3. `SetAlgebra` conformance: `union`, `intersection`, `symmetricDifference`, `insert`, `remove`, `contains`.

**Done when**
- [ ] `contains` is O(1), not O(n)
- [ ] `Array(orderedSet)` preserves insertion order
- [ ] `union` of two sets yields a deterministic order, and the rule is documented
- [ ] The two protocols don't conflict: `count`, `isEmpty`, `first` are unambiguous

**Pitfall** `SetAlgebra` and `Collection` both require `insert`/`remove`-like operations with different signatures, and `SetAlgebra.init()` conflicts with `RangeReplaceableCollection.init()`. Resolve the conflicts explicitly, not via `@_disfavoredOverload`.

---

### `SEQ-14` · A tree with two traversals ⏱ 30

**Task**
1. `struct Tree<Element> { let value: Element; let children: [Tree] }`.
2. `struct DepthFirstSequence<Element>: Sequence` and `struct BreadthFirstSequence<Element>: Sequence`.
3. On the tree — properties `var dfs: DepthFirstSequence<Element>` and `var bfs: BreadthFirstSequence<Element>`.

**Done when**
- [ ] `Array(tree.dfs)` and `Array(tree.bfs)` yield different orders on a tree of depth 3
- [ ] Neither iterator uses recursion (only an explicit stack/queue)
- [ ] `tree.dfs.first(where:)` finishes early, without traversing the whole tree

**Pitfall** It's tempting to write `func traverse(order: TraversalOrder)` with an enum parameter. Then there's a `switch` inside and two implementations in one method. Separate types are OCP: a third traversal is added without changing the existing ones.

---

### `SEQ-15` · A `Trie` with lazy search ⏱ 45

**Task**
1. `struct Trie` with `insert(_ word: String)` and `contains(_ word: String)`.
2. `Sequence` conformance — iterates over all words.
3. `func words(startingWith prefix: String) -> some Sequence<String>` — **lazy**, without building an array.

**Done when**
- [ ] Inserting 1000 words and `contains` work correctly
- [ ] `words(startingWith: "ab").prefix(3)` doesn't traverse the whole subtree
- [ ] Proven by a log: exactly as many nodes were visited as needed for 3 words
- [ ] An empty prefix returns all words

**Pitfall** Lazily returning results from a recursive structure is nearly impossible with recursion. You need an iterator with an explicit stack of state `(node, accumulated prefix)`.

---

### `SEQ-16` · `PriorityQueue` — and why not `Collection` ⏱ 30

**Task**
1. `struct PriorityQueue<Element: Comparable>` on a binary heap in an array.
2. `enqueue`, `dequeue`, `peek`, `count`.
3. Write a doc comment justifying why the type does **not** conform to `Collection`.

**Done when**
- [ ] `dequeue` always returns the minimum (or maximum) — tested with 20 random inserts
- [ ] There is no `Collection` conformance
- [ ] The justification is specific: the storage order isn't the logical order; `Collection` promises a stable traversal, and a heap doesn't have one
- [ ] Instead of `Collection` there's `func drain() -> some Sequence<Element>` that yields elements by priority

**Pitfall** This is the most important kata in the section. A formal conformance is easy: just expose `storage` as is. But then `for in` yields heap order rather than priority order — a silent design-level bug.

---

### `SEQ-17` · `LazyChunkedSequence` ⏱ 30

**Task**
1. `struct LazyChunkedSequence<Base: Sequence>: LazySequenceProtocol` with `Element == [Base.Element]`.
2. `extension LazySequenceProtocol { func chunks(of size: Int) -> LazyChunkedSequence<Elements> }`.
3. Check it in a chain: `array.lazy.filter { ... }.chunks(of: 3).map { ... }.first`.

**Done when**
- [ ] The whole chain is lazy: logs prove `filter` was called only for the first few elements
- [ ] Without `.lazy` the method is unavailable
- [ ] `chunks(of: 3)` on 10 elements yields 4 chunks, the last one with 1

**Pitfall** `LazySequenceProtocol` requires `var elements: Elements`. If you return a plain `Sequence`, the chain "collapses" into an eager one at your step — and the rest of the optimization is lost.

---

### `SEQ-18` · `Zip3Sequence` ⏱ 30

**Task**
1. `struct Zip3Sequence<A: Sequence, B: Sequence, C: Sequence>: Sequence` with `Element == (A.Element, B.Element, C.Element)`.
2. The iterator holds three iterators and finishes when the **shortest** one runs out.
3. A free function `func zip<A, B, C>(_ a: A, _ b: B, _ c: C) -> Zip3Sequence<A, B, C>`.

**Done when**
- [ ] `zip([1,2,3], "abc", [true, false])` yields 2 elements
- [ ] The type works with the infinite sequence from `SEQ-01` as one of the arguments
- [ ] `underestimatedCount` is implemented as the minimum of the three

**Pitfall** If the first iterator is exhausted, don't pull the others — otherwise an infinite sequence or a sequence with side effects will behave unexpectedly.

---

### `SEQ-19` · A custom `AsyncSequence` ⏱ 45

**Task**
1. `struct PaginatedFeed<Item: Decodable>: AsyncSequence` with `Element == Item`.
2. The `AsyncIterator` fetches the next page when the current one is exhausted.
3. Support cancellation via `Task.checkCancellation()` and finish when a page comes back empty.

**Done when**
- [ ] `for try await item in feed` yields the elements of three pages in a row
- [ ] Exactly 3 network calls for 3 pages — not 4, and not 1 per element
- [ ] `task.cancel()` in the middle of the second page ends the loop correctly
- [ ] `feed.prefix(5)` (the async variant) doesn't load the third page

**Pitfall** `next()` in `AsyncIteratorProtocol` must be `mutating` and `async throws`. If the iterator is a `class`, value semantics are gone and two `for await` loops over one feed will corrupt each other.

---

### `SEQ-20` · `WeakArray` ⏱ 30

**Task**
1. `struct WeakBox<T: AnyObject> { weak var value: T? }` and `struct WeakArray<T: AnyObject>`.
2. `Collection` conformance with `Element == T?`.
3. Add `mutating func compact()` that drops deallocated slots.

**Done when**
- [ ] Once an object goes out of scope, its element becomes `nil` **without** any action on your part
- [ ] `count` includes nil slots before `compact()`, and doesn't after
- [ ] A comment explains why `Element` must be `T?` and not `T`

**Pitfall** This is a collection whose contents change on their own. So `count` isn't stable between two reads — formally a violation of the `Collection` contract. Record that in a doc comment.

---

### `SEQ-21` · CoW for your own struct ⏱ 45

**Task**
1. Take `SEQ-06` or `SEQ-08` and move the storage into a `final class Storage`.
2. Add `private mutating func ensureUnique()` using `isKnownUniquelyReferenced`.
3. Add a static copy counter and write three tests.

**Done when**
- [ ] Passing the struct to a function — 0 copies
- [ ] Reading from a copy — 0 copies
- [ ] Writing to a copy — exactly 1 copy, the original is unchanged
- [ ] `ensureUnique()` is called in **every** mutating method — verify that none is missed

**Pitfall** A missed `ensureUnique()` call in one mutating method causes a bug that shows up only with a specific sequence of operations. A copy counter + a test for each mutating method is the only reliable approach.

---

**Next:** `TASKS-3` — Codable, services, concurrency.
