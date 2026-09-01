// Kata:
// Format a past date as "2 hours ago" — once with RelativeDateTimeFormatter,
// once with .formatted(.relative(presentation:)).

import Foundation

extension TimeInterval {

    static let hour: TimeInterval = 60 * 60
}

// MARK: - RelativeDateTimeFormatter

extension RelativeDateTimeFormatter {

    /// Shared instance: creating a formatter is expensive and this configuration never changes.
    static let numeric: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .numeric
        return formatter
    }()
}

extension Date {

    func relativeDescription(to referenceDate: Date = .now) -> String {
        RelativeDateTimeFormatter.numeric.localizedString(for: self, relativeTo: referenceDate)
    }
}

// MARK: - Date.RelativeFormatStyle

extension Date {

    /// Always relative to now: the style has no reference date to pass.
    func relativeFormattedDescription() -> String {
        formatted(.relative(presentation: .numeric))
    }
}

// MARK: - Usage

let twoHoursAgo = Date.now.addingTimeInterval(-2 * .hour)

let formatterText = twoHoursAgo.relativeDescription()
let formatStyleText = twoHoursAgo.relativeFormattedDescription()

print(formatterText)
print(formatStyleText)
print("Both spellings agree:", formatterText == formatStyleText)

// .named prefers words over numbers where the locale has one — "yesterday" instead of "1 day ago".
let yesterday = Date.now.addingTimeInterval(-24 * .hour)

print(yesterday.formatted(.relative(presentation: .named)))
