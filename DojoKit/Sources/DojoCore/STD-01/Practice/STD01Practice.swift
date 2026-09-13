// STD-01 · Two descriptions for one type · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Take a model with 5+ fields, including optionals and a date.
// 2. `CustomStringConvertible` → a short string for UI/info-level logs.
// 3. `CustomDebugStringConvertible` → all fields, including `id` and technical flags.
//
// Done when
// - [ ] `print(model)` and `debugPrint(model)` produce different output
// - [ ] `description` doesn't contain `id`; `debugDescription` does
// - [ ] `"\(model)"` in string interpolation uses `description`
//
// Pitfall
// `String(describing:)` and `String(reflecting:)` use different protocols — check both.
