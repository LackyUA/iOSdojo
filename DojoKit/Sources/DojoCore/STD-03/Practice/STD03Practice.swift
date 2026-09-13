// STD-03 · `Hashable` by `id` only · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. A model with an `id` and three mutable fields (`name`, `updatedAt`, `isFavorite`).
// 2. Implement `==` and `hash(into:)` using `id` only.
// 3. Demonstrate the consequence: put two objects with the same `id` and different `name` into a `Set` and see what
//    remains.
//
// Done when
// - [ ] The `Set` contains one element, and you can tell which of the two it is
// - [ ] A comment explains when this implementation is correct (a database entity) and when it's a bug (a value type)
// - [ ] A `Dictionary` keyed by this model behaves predictably after a field mutation
//
// Pitfall
// You didn't break the rule `a == b ⟹ a.hashValue == b.hashValue`. But you did break the expectation that "equal
// objects are interchangeable". That's the whole point of the kata.
