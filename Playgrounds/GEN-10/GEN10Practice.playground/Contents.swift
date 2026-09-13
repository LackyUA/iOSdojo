// GEN-10 · Returning `some Collection` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. A function `func activeItems(in items: [Item]) -> [Item]` using `.filter`.
// 2. Change the return type to `some Collection<Item>` and return `items.lazy.filter { ... }`.
// 3. At the call site, try `result.append(...)` and `result[0]`.
//
// Done when
// - [ ] The caller doesn't know there's a `LazyFilterCollection` inside
// - [ ] `append` doesn't compile, indexing works
// - [ ] Switching the implementation to `Array` doesn't break any call site
//
// Pitfall
// `some Collection<Item>` pins **one** concrete type for all returns. Two `if` branches returning different collection
// types won't compile.
