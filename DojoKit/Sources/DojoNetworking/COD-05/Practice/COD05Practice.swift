// COD-05 · Lossy array · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `struct LossyArray<Element: Decodable>: Decodable` with an `elements: [Element]` property.
// 2. Inside — an `unkeyedContainer` and a loop that catches the error on each element and skips it.
// 3. Add `errors: [Error]` for reporting.
//
// Done when
// - [ ] JSON with 5 objects, where the 2nd is malformed, yields 4 elements
// - [ ] `errors.count == 1` and the error includes the index
// - [ ] Used in a real model: `@LossyArray var items: [Item]` or via a wrapper property
//
// Pitfall
// After a failed `decode`, the `UnkeyedDecodingContainer` cursor doesn't advance on its own — you need an "empty"
// placeholder type to skip the element: `_ = try? container.decode(AnyDecodable.self)`.
