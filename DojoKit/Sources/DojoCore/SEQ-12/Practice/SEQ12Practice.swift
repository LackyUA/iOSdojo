// SEQ-12 · Index invalidation · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Take `SEQ-11`. Get `let i = list.index(after: list.startIndex)`.
// 2. Remove an element before `i`, then try `list[i]`.
// 3. Document in a doc comment above the type which operations invalidate indices.
//
// Done when
// - [ ] The post-invalidation behavior is reproduced in a test (a crash, a wrong value, or correct behavior)
// - [ ] The doc comment states the contract as explicitly as `Array` does in the stdlib
// - [ ] Compared with `Array`: indices get invalidated there too, but more "quietly"
//
// Pitfall
// This kata isn't about code, it's about the contract. A `Collection` is a set of promises about complexity and index
// validity. Break a promise silently and you've created a bug someone will find six months later.
