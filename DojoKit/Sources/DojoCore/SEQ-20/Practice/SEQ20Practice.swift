// SEQ-20 · `WeakArray` · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct WeakBox<T: AnyObject> { weak var value: T? }` and `struct WeakArray<T: AnyObject>`.
// 2. `Collection` conformance with `Element == T?`.
// 3. Add `mutating func compact()` that drops deallocated slots.
//
// Done when
// - [ ] Once an object goes out of scope, its element becomes `nil` without any action on your part
// - [ ] `count` includes nil slots before `compact()`, and doesn't after
// - [ ] A comment explains why `Element` must be `T?` and not `T`
//
// Pitfall
// This is a collection whose contents change on their own. So `count` isn't stable between two reads — formally a
// violation of the `Collection` contract. Record that in a doc comment.
