import Foundation

// Kata:
// Format current date into "year.month.day - X quarter" string.

let formatter = DateFormatter()

formatter.timeZone = TimeZone(abbreviation: "UTC")
formatter.dateFormat = "yyyy.MM.dd - QQQQ"

print(formatter.string(from: Date()))
