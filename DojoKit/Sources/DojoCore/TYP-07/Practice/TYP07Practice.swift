// TYP-07 · DIY CoW · ⏱ 15 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. `final class Box<T> { var value: T }` and `struct Wrapper<T> { private var box: Box<T> }`.
// 2. First, without CoW: mutate `wrapper2` and observe that `wrapper1` changed too. Capture this in a test.
// 3. In the mutating method, add an `isKnownUniquelyReferenced(&box)` check and copy if the reference isn't unique.
//
// Done when
// - [ ] The first test (without CoW) demonstrates "broken" value semantics
// - [ ] After the fix, the same test shows the copies are independent
// - [ ] A copy counter proves that a copy happens only on write, not on pass
//
// Pitfall
// `isKnownUniquelyReferenced` requires `inout` and doesn't work with `let box`. It also doesn't work with classes that
// have Objective-C references.
