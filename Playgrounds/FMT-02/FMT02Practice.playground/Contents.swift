// FMT-02 · "2 hours ago" · ⏱ 5 min — practice
// Task: TASKS-1-foundations.md
//
// Task
// 1. Write `func relative(_ date: Date, to reference: Date = .now, locale: Locale) -> String`.
// 2. Use `RelativeDateTimeFormatter` with `unitsStyle = .full` and `dateTimeStyle = .named`.
// 3. Check five inputs: 30 seconds, 2 hours, 1 day, 3 days, and 2 weeks ago.
//
// Done when
// - [ ] For "1 day ago", the Ukrainian locale yields "вчора" (yesterday), not "1 день тому"
// - [ ] The function is pure: `reference` is injected rather than taken from `Date()` inside
// - [ ] The formatter is created once, not on every call
//
// Pitfall
// `RelativeDateTimeFormatter` is expensive to create — keep it in a `static let`.
