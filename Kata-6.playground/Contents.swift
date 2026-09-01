// Kata:
// Parse "2026-09-01" with Date.ParseStrategy anchored to the Europe/Kyiv time zone at noon,
// so the calendar day is stable in any client time zone.

import Foundation

enum KyivDayError: Error {
    case unreadableDay(String)
    case unreachableNoon(Date)
}

// MARK: - Business time zone

extension TimeZone {

    /// The business time zone: a day published by the backend is a Kyiv day, whatever the device is set to.
    static let kyiv: TimeZone = {
        guard let kyiv = TimeZone(identifier: "Europe/Kyiv") else {
            preconditionFailure("Time zone must be available.")
        }
        return kyiv
    }()
}

extension Calendar {

    /// Shared instance: day boundaries have to be measured in Kyiv, not in the device's zone.
    static let kyiv: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .kyiv
        return calendar
    }()
}

// MARK: - Parsing

extension ParseStrategy where Self == Date.ParseStrategy {

    /// Reads a bare `yyyy-MM-dd` as Kyiv wall-clock time, so the string lands on midnight in Kyiv.
    ///
    /// Written against the protocol rather than the concrete type: that is what gives
    /// `Date(_:strategy:)` the leading dot.
    static var kyivDay: Self {
        // Lenient is the default and it does not fail on junk, it guesses:
        // "01.09.2026" becomes 19 March 2007 and "2026-13-45" rolls over into February 2027.
        Self(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
            timeZone: .kyiv,
            isLenient: false
        )
    }
}

extension Date {

    /// Creates a `Date` from a Kyiv date string (`yyyy-MM-dd`), anchored to noon so the calendar day
    /// survives being formatted in any zone from UTC-9 east to UTC+14.
    init(kyivDayString value: String) throws(KyivDayError) {
        let midnight: Date
        do {
            midnight = try Date(value, strategy: .kyivDay)
        } catch {
            throw .unreadableDay(value)
        }
        // Noon set through the calendar, not `addingTimeInterval(12 * 60 * 60)`:
        // on a DST switch the day is not 24 hours long and the fixed offset misses noon by an hour.
        guard let noon = Calendar.kyiv.date(bySettingHour: 12, minute: 0, second: 0, of: midnight) else {
            throw .unreachableNoon(midnight)
        }
        self = noon
    }
}

// MARK: - Usage

/// Zones from both ends of the map: the far east reads the date first, the far west last.
let clientTimeZones = ["Europe/Kyiv", "UTC", "America/Los_Angeles", "Pacific/Kiritimati", "Pacific/Midway"]
    .compactMap(TimeZone.init(identifier:))

let publishedDay = DateComponents(year: 2026, month: 9, day: 1)

func day(_ date: Date, in timeZone: TimeZone) -> String {
    date.formatted(Date.FormatStyle(date: .abbreviated, time: .shortened, timeZone: timeZone))
}

/// The calendar day a client in `timeZone` actually sees.
func showsPublishedDay(_ date: Date, in timeZone: TimeZone) -> Bool {
    var calendar = Calendar.kyiv
    calendar.timeZone = timeZone
    return calendar.dateComponents([.year, .month, .day], from: date) == publishedDay
}

do {
    let noon = try Date(kyivDayString: "2026-09-01")
    let midnight = try Date("2026-09-01", strategy: .kyivDay)

    print("Anchored in Kyiv:", day(noon, in: .kyiv))

    for timeZone in clientTimeZones {
        let verdict = showsPublishedDay(noon, in: timeZone) ? "1 Sep" : "slipped"
        let noonDay = day(noon, in: timeZone)
        let midnightDay = day(midnight, in: timeZone)
        print("\(timeZone.identifier): noon \(noonDay) — \(verdict) | midnight \(midnightDay)")
    }

    // Noon in Kyiv is 09:00 UTC in summer, so the day holds from UTC-9 east to UTC+14 — every market the app sells in.
    // Midnight holds nowhere west of Kyiv, and Samoa at UTC-11 is past even the noon anchor: that one needs noon UTC.
    print("Midnight anchor survives anywhere:", clientTimeZones.allSatisfy { showsPublishedDay(midnight, in: $0) })
    print("Noon anchor survives anywhere:", clientTimeZones.allSatisfy { showsPublishedDay(noon, in: $0) })

    // Strictness is the reason this line reports a failure instead of quietly returning March 2007.
    _ = try Date(kyivDayString: "01.09.2026")
} catch {
    print("Parsing failed:", error)
}
