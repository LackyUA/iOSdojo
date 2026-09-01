# iOS dojo 🥋
A place to train skills. 👊

Each kata is a standalone Swift playground. Open the one you want and run it.
Like in karate, katas are small and repeatable: every task drills one everyday
skill, takes 10–30 minutes, and needs no UI.

# List of Foundation katas
1. Format string "Saturday, 30 May 2020, 1:13:13 PM" to date.
2. Format current date into "year.month.day - X quarter" string.
3. Create stack using array as storage.
4. Create property wrapper for Capitalizing Text.
5. Parse ISO 8601 string "2026-09-01T12:30:45Z" into Date and format it back — once with ISO8601DateFormatter, once with Date.ISO8601FormatStyle.
6. Format a past date as "2 hours ago" — once with RelativeDateTimeFormatter, once with .formatted(.relative(presentation:)).
7. Using Calendar, count full days between two dates and find the date of the next Monday.
8. Show why 0.1 + 0.2 != 0.3 in Double, then sum a list of prices exactly using Decimal.
9. Format 1234567.89 as currency for the en_US and uk_UA locales — once with NumberFormatter, once with .formatted(.currency(code:)).
10. Convert 42.195 kilometers to miles with Measurement and print it localized.
11. Make a Money struct conform to Equatable and Hashable by hand, without synthesized conformance.
12. Make a Version struct Comparable so that "1.2.10" is greater than "1.2.9".
13. Give a Temperature struct a readable description with CustomStringConvertible.
14. Model weekdays as a CaseIterable enum and print the working days using its allCases.
15. Remove duplicates from an array while preserving element order.
16. Count word frequency in a text using Dictionary(grouping:) or reduce(into:).
17. Check whether a sentence is a palindrome, ignoring case, punctuation and diacritics.
18. Round-trip a struct through JSON: decode snake_case keys and ISO 8601 dates, encode back pretty-printed.
19. Write a throwing parser with a custom Error enum and call it twice: with do/catch and with Result.
20. Extract all #hashtags from a string with Swift Regex.
