// Kata:
// Format string "Saturday, 30 May 2020 at 1:13:13 PM" to date.

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    static var fullDateTime: Date.FormatStyle {
        .init(date: .complete, time: .standard, locale: Locale(identifier: "en_001"), timeZone: .gmt)
    }
}

extension Date {
    init(fullDateTimeString value: String) throws {
        self = try Date(value, strategy: Date.FormatStyle.fullDateTime.parseStrategy)
    }
}

// MARK: - Usage

let stringDate = "Saturday, 30 May 2020 at 1:13:13 PM"

do {
    print(try Date(fullDateTimeString: stringDate))
} catch {
    print("Parsing failed:", error)
}
