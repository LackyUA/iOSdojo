// FMT-01 · Three date formats · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Create `let date = Date(timeIntervalSince1970: 1_726_099_200)`.
// 2. Print it three ways using `Date.FormatStyle`: full date with the month name, ISO 8601, and relative format.
// 3. Repeat the output for the `uk_UA` and `en_US` locales by passing `.locale(_:)` to the style.
//
// Done when
// - [ ] Three different strings in the console for the same date
// - [ ] The Ukrainian and English locales produce different results
// - [ ] The file contains no mention of `DateFormatter`
//
// Pitfall
// `.iso8601` is a separate `Date.ISO8601FormatStyle`, not a case of `FormatStyle`.
