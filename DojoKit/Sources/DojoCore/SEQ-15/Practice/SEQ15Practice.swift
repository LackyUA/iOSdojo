// SEQ-15 · A `Trie` with lazy search · ⏱ 45 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Trie` with `insert(_ word: String)` and `contains(_ word: String)`.
// 2. `Sequence` conformance — iterates over all words.
// 3. `func words(startingWith prefix: String) -> some Sequence<String>` — lazy, without building an array.
//
// Done when
// - [ ] Inserting 1000 words and `contains` work correctly
// - [ ] `words(startingWith: "ab").prefix(3)` doesn't traverse the whole subtree
// - [ ] Proven by a log: exactly as many nodes were visited as needed for 3 words
// - [ ] An empty prefix returns all words
//
// Pitfall
// Lazily returning results from a recursive structure is nearly impossible with recursion. You need an iterator with an
// explicit stack of state `(node, accumulated prefix)`.
