// SEQ-19 · A custom `AsyncSequence` · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct PaginatedFeed<Item: Decodable>: AsyncSequence` with `Element == Item`.
// 2. The `AsyncIterator` fetches the next page when the current one is exhausted.
// 3. Support cancellation via `Task.checkCancellation()` and finish when a page comes back empty.
//
// Done when
// - [ ] `for try await item in feed` yields the elements of three pages in a row
// - [ ] Exactly 3 network calls for 3 pages — not 4, and not 1 per element
// - [ ] `task.cancel()` in the middle of the second page ends the loop correctly
// - [ ] `feed.prefix(5)` (the async variant) doesn't load the third page
//
// Pitfall
// `next()` in `AsyncIteratorProtocol` must be `mutating` and `async throws`. If the iterator is a `class`, value
// semantics are gone and two `for await` loops over one feed will corrupt each other.
