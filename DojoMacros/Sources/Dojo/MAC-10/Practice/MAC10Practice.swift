// MAC-10 · `@SnakeCaseCodable` · ⏱ 30 min — practice, public declaration
// Task: TASKS-5-macros.md
//
// Task
// 1. `@attached(extension, conformances: Codable, names: named(CodingKeys)) macro SnakeCaseCodable()`.
// 2. It generates `extension X: Codable` and a nested `enum CodingKeys: String, CodingKey` with camelCase → snake_case
//    mapping.
// 3. Support `@CodableKey("custom_name")` on an individual property as an override.
//
// Done when
// - [ ] `userName` maps to `"user_name"`
// - [ ] `avatarURL` maps to `"avatar_url"` (not `"avatar_u_r_l"`)
// - [ ] The attribute override works
// - [ ] An expansion test compares the generated `CodingKeys` character by character
//
// Pitfall
// Abbreviations (`URL`, `ID`, `HTTPStatus`) are the main difficulty of the conversion.
// `JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase` breaks them too; your macro has a chance to do better, but
// that has to be implemented deliberately.
