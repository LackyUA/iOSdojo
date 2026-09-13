// GEN-03 · `Cache<Key, Value>` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `final class Cache<Key: Hashable, Value>` with `limit: Int`.
// 2. `subscript(key: Key) -> Value?` for both reading and writing.
// 3. When the limit is exceeded, evict the oldest element (FIFO is enough, LRU is a bonus).
//
// Done when
// - [ ] After 101 inserts with `limit = 100` the size is exactly 100
// - [ ] The evicted element is exactly the one you expect — proven by a test
// - [ ] The type works with `Key = String` and `Key = ID<User>` from `TYP-03` without changes
//
// Pitfall
// Eviction order needs a second structure (an array of keys or a linked list). `Dictionary` doesn't preserve order.
