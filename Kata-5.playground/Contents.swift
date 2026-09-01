// Kata:
// Using Calendar, count full days between two dates and find the date of the next Monday.

import Foundation

enum CalendarError: Error {
    case unresolvedDate(DateComponents)
}

extension Calendar {

    /// Shared instance: `.iso8601` starts its weeks on Monday whatever the device locale says.
    static let iso8601: Calendar = .init(identifier: .iso8601)

    /// Foundation numbers weekdays from Sunday, so Monday is always 2 — the calendar identifier does not change that.
    private static let mondayIndex = 2
}

// MARK: - Counting days

extension Calendar {

    /// Whole days that fit between the two instants: 47 hours are still one full day.
    func fullDays(from start: Date, to end: Date) -> Int {
        dateComponents([.day], from: start, to: end).day ?? 0
    }

    /// Days between the two calendar dates, ignoring the time of day: 23:00 to 01:00 the next night is one day.
    ///
    /// Day boundaries come from the calendar's own `timeZone`, so pin it when the result has to be stable.
    func calendarDays(from start: Date, to end: Date) -> Int {
        dateComponents([.day], from: startOfDay(for: start), to: startOfDay(for: end)).day ?? 0
    }
}

// MARK: - Next Monday

extension Calendar {

    /// Start of the first Monday strictly after `date` — a date that already is a Monday returns the following one.
    func nextMonday(after date: Date) throws -> Date {
        let mondayStart = DateComponents(hour: 0, minute: 0, second: 0, weekday: Self.mondayIndex)
        guard let monday = nextDate(after: date, matching: mondayStart, matchingPolicy: .nextTime) else {
            throw CalendarError.unresolvedDate(mondayStart)
        }
        return monday
    }
}

// MARK: - Usage

var calendar = Calendar.iso8601
calendar.timeZone = .gmt

let dayAndTime = Date.FormatStyle(date: .abbreviated, time: .shortened, timeZone: .gmt).weekday(.wide)

do {
    let start = try Date("2026-09-01T22:00:00Z", strategy: .iso8601)
    let end = try Date("2026-09-04T08:00:00Z", strategy: .iso8601)

    print("From:", start.formatted(dayAndTime))
    print("To:", end.formatted(dayAndTime))

    print("Full days:", calendar.fullDays(from: start, to: end))
    print("Calendar days:", calendar.calendarDays(from: start, to: end))

    let monday = try calendar.nextMonday(after: start)
    print("Next Monday:", monday.formatted(dayAndTime))
    print("Days until it:", calendar.calendarDays(from: start, to: monday))

    print("Monday after that:", try calendar.nextMonday(after: monday).formatted(dayAndTime))
} catch {
    print("Failed:", error)
}
