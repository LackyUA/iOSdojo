// Kata:
// Parse ISO 8601 string "2026-09-01T12:30:45Z" into Date and format it back —
// once with ISO8601DateFormatter, once with Date.ISO8601FormatStyle.

import Foundation

enum ISO8601ParsingError: Error {
    case invalidDateString(String)
}

// MARK: - ISO8601DateFormatter

extension ISO8601DateFormatter {

    /// Shared instance: creating a formatter is expensive and this configuration never changes.
    static let internetDateTime: ISO8601DateFormatter = .init()
}

extension Date {

    init(internetDateTimeString value: String) throws {
        guard let date = ISO8601DateFormatter.internetDateTime.date(from: value) else {
            throw ISO8601ParsingError.invalidDateString(value)
        }
        self = date
    }
}

// MARK: - Date.ISO8601FormatStyle

extension Date {

    init(iso8601String value: String) throws {
        self = try Date(value, strategy: .iso8601)
    }
}

// MARK: - Usage

let stringDate = "2026-09-01T12:30:45Z"

do {
    let formatterDate = try Date(internetDateTimeString: stringDate)
    print(ISO8601DateFormatter.internetDateTime.string(from: formatterDate))

    let formatStyleDate = try Date(iso8601String: stringDate)
    print(formatStyleDate.formatted(.iso8601))

    print("Both round trips agree:", formatterDate == formatStyleDate)
} catch {
    let error = ISO8601ParsingError.invalidDateString(error.localizedDescription)
    print("Parsing failed:", error)
}
