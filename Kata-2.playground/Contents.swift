// Kata:
// Format current date into "year.month.day - X quarter" string.

import Foundation

extension Date {

    struct DateWithQuarterFormatStyle: Foundation.FormatStyle {

        // MARK: - FormatStyle

        func format(_ date: Date) -> String {
            let verbatimStyle = Date.VerbatimFormatStyle(
                format: "\(year: .defaultDigits).\(month: .twoDigits).\(day: .twoDigits) - \(quarter: .wide)",
                locale: .current,
                timeZone: .current,
                calendar: .current
            )
            return date.formatted(verbatimStyle)
        }
    }
}

extension FormatStyle where Self == Date.DateWithQuarterFormatStyle {
    static var dateWithQuarter: Self {
        .init()
    }
}

// MARK: - Usage

print(Date.now.formatted(.dateWithQuarter))
