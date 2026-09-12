// FMT-02 · "2 hours ago" · ⏱ 5 min — reference solution
// Task: TASKS-1-foundations.md

import Foundation
import Synchronization

extension TimeInterval {

    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60 * minute
    static let day: TimeInterval = 24 * hour
}

extension RelativeDateTimeFormatter {

    /// Returns the time from `reference` to `date` as localized text.
    ///
    /// The text uses words such as "yesterday" when the locale has them.
    static func namedString(for date: Date, relativeTo reference: Date, locale: Locale) -> String {
        namedFormatters.withLock { formatters in
            let formatter = formatters[locale.identifier] ?? makeNamedFormatter(locale: locale)
            formatters[locale.identifier] = formatter
            return formatter.localizedString(for: date, relativeTo: reference)
        }
    }

    // MARK: - Private Properties

    /// One formatter for each locale identifier.
    ///
    /// Creating a formatter is expensive, so each formatter is kept for reuse. The mutex serializes access to the
    /// formatters, and only the formatted `String` leaves the lock.
    private static let namedFormatters = Mutex<[String: RelativeDateTimeFormatter]>([:])

    // MARK: - Private Methods

    private static func makeNamedFormatter(locale: Locale) -> RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named
        formatter.locale = locale
        return formatter
    }
}

/// Returns the time from `reference` to `date` as localized text, for example "2 hours ago".
func relative(_ date: Date, to reference: Date = .now, locale: Locale) -> String {
    RelativeDateTimeFormatter.namedString(for: date, relativeTo: reference, locale: locale)
}

// MARK: - Usage

// A fixed reference keeps the output stable. Only the call site decides what "now" is.
let reference = Date(timeIntervalSince1970: 1_726_099_200)
let intervals: [TimeInterval] = [30, 2 * .hour, .day, 3 * .day, 14 * .day]

for locale in [Locale(identifier: "uk_UA"), Locale(identifier: "en_US")] {
    print(locale.identifier)
    for interval in intervals {
        print(relative(reference.addingTimeInterval(-interval), to: reference, locale: locale))
    }
}

// ICU spells the named Ukrainian form "учора". "вчора" is an equally valid spelling.
// Either way the named style says "yesterday" instead of "1 день тому".
