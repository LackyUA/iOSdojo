// FMT-01 · Three date formats · ⏱ 5 min — reference solution
// Task: TASKS-1-foundations.md

import Foundation

extension FormatStyle where Self == Date.FormatStyle {

    /// Formats a date as the day, the full month name, and the year.
    static func fullDate(locale: Locale) -> Self {
        .dateTime.day().month(.wide).year().locale(locale)
    }
}

extension FormatStyle where Self == Date.RelativeFormatStyle {

    /// Formats a date relative to now. Uses words such as "yesterday" when the locale has them.
    static func namedRelative(locale: Locale) -> Self {
        .relative(presentation: .named).locale(locale)
    }
}

// MARK: - Usage

let date = Date(timeIntervalSince1970: 1_726_099_200)

for locale in [Locale(identifier: "uk_UA"), Locale(identifier: "en_US")] {
    print(locale.identifier)
    print(date.formatted(.fullDate(locale: locale)))
    print(date.formatted(.iso8601))
    print(date.formatted(.namedRelative(locale: locale)) + "\n")
}
