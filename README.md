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
21. Build a Money type: a Decimal amount plus a Currency struct over ISO codes, with + and - operators that throw a typed MoneyError.currencyMismatch. Decide what Comparable's < should do when currencies differ.
22. Extend Money with init(amount: Int, currency:) that treats the Int as minor units (kopecks) and stores amount / 100.
23. Write a generic clamp(value:to:) over Comparable and inverseLerp over BinaryFloatingPoint.
24. Create your own FormatStyle that formats a rating as "4.8 ★", with a static accessor so call sites read value.formatted(.rating).
25. Format a product count with Ukrainian pluralization — "1 товар, 2 товари, 5 товарів" — capping large values as "10 000+".
26. Format "380671234567" as "+380 67 123 45 67": normalize the leading "+" and group the digits.
27. Parse "2026-09-01" with Date.ParseStrategy anchored to the Europe/Kyiv time zone at noon, so the calendar day is stable in any client time zone.
28. Format a date as a day with genitive month name — "3 вересня" — using Date.VerbatimFormatStyle.
29. Add subscript(safe:) to Collection that returns nil instead of crashing on an out-of-bounds index.
30. Split an array into chunks of a given size using stride.
31. Write Sequence.ranked(by:reference:) that orders elements by a reference ranking list; unknown elements go last, keeping their original order.
32. Make a type-safe UniqueIdentifier<Value, RawValue> phantom type, so a product ID cannot be passed where an order ID is expected, with conditional CustomStringConvertible conformance.
33. Write concurrently(_:_:) that runs two async operations with async let and returns both results as a tuple.
34. Wrap NSCache in a generic Cache<Key, Value> and discover why keys and values must be boxed in classes.
