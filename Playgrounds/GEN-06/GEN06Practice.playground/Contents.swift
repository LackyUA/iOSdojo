// GEN-06 · Sorting by `KeyPath` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `extension Sequence { func sorted<V: Comparable>(by keyPath: KeyPath<Element, V>) -> [Element] }`.
// 2. Add an overload with an `order: SortOrder` parameter.
// 3. Bonus: `sorted(by: \.department, then: \.lastName)`.
//
// Done when
// - [ ] `people.sorted(by: \.age)` works
// - [ ] No call site passes a `{ $0.age < $1.age }` closure
// - [ ] The two-key variant sorts stably
//
// Pitfall
// The standard library already has `sorted(using:)` with `SortComparator` (iOS 15+). Compare your API with it and say
// in a comment whether writing your own was worth it.
