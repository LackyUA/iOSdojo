import Foundation

// Kata:
// Format string "Saturday, 30 May 2020, 1:13:13 PM" to date.

let stringDate = "Saturday, 30 May 2020, 1:13:13 PM"
let formatter = DateFormatter()

formatter.timeZone = TimeZone(abbreviation: "UTC")
formatter.dateFormat = "EEEE, dd MMMM yyyy, hh:mm:ss a"

print(formatter.date(from: stringDate) ?? "")
