// COD-01 · Nested `Codable` · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. Take JSON where the field you need sits three levels deep: `{"data": {"user": {"profile": {"name": "..."}}}}`.
// 2. Decode it into a flat model `User { name: String, avatarURL: URL? }` using a custom `init(from:)` and
//    `nestedContainer`.
// 3. Add a field whose JSON key is snake_case, via `CodingKeys`.
//
// Done when
// - [ ] The model is flat — no three intermediate structs `DataDTO`/`UserDTO`/`ProfileDTO`
// - [ ] A missing optional key doesn't break decoding
// - [ ] `decodeIfPresent` is used exactly where the field is genuinely optional
//
// Pitfall
// `nestedContainer(keyedBy:forKey:)` throws if the key is missing. For an optional nesting level you need `try?` or a
// separate `contains` check.
