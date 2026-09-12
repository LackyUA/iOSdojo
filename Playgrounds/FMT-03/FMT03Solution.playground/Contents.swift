// FMT-03 · `Money` type · ⏱ 5 min — reference solution
// Task: TASKS-1-foundations.md

import Foundation

enum Currency: String, Sendable {
    case uah = "UAH"
    case usd = "USD"
}

enum MoneyError: Error {
    case currencyMismatch(Currency, Currency)
}

/// A monetary value represented by an amount and a currency.
struct Money: Sendable, Hashable {

    /// Creates money from an amount in minor units, such as kopecks or cents.
    init(amount: Int, currency: Currency) {
        self.amount = Decimal(amount) / 100
        self.currency = currency
    }

    init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }

    /// The amount in the given currency.
    let amount: Decimal

    /// Currency.
    let currency: Currency
}

// MARK: - Arithmetic

extension Money {

    /// Adds two amounts in the same currency.
    ///
    /// - Throws: `MoneyError.currencyMismatch` if the currencies are different.
    static func + (lhs: Money, rhs: Money) throws(MoneyError) -> Money {
        guard lhs.currency == rhs.currency else {
            throw .currencyMismatch(lhs.currency, rhs.currency)
        }
        return Money(amount: lhs.amount + rhs.amount, currency: lhs.currency)
    }
}

// MARK: - Formatting

extension Money {

    struct PriceFormatStyle: FormatStyle, Sendable {

        init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        // MARK: - FormatStyle

        func format(_ money: Money) -> String {
            money.amount.formatted(.currency(code: money.currency.rawValue).locale(locale))
        }

        // MARK: - Private Properties

        private let locale: Locale
    }

    func formatted() -> String {
        formatted(.money)
    }

    func formatted<Style: FormatStyle>(_ style: Style) -> Style.FormatOutput where Style.FormatInput == Self {
        style.format(self)
    }
}

extension FormatStyle where Self == Money.PriceFormatStyle {

    static var money: Self {
        .init()
    }

    static func money(locale: Locale) -> Self {
        .init(locale: locale)
    }
}

// MARK: - Usage

let tenKopecks = Money(amount: 10, currency: .uah)
let twentyKopecks = Money(amount: 20, currency: .uah)

do {
    let sum = try tenKopecks + twentyKopecks
    print(sum.formatted())
    print(sum.formatted(.money(locale: Locale(identifier: "uk_UA"))))
    print("Exactly 0.3:", sum.amount == Decimal(3) / 10)

    // A floating-point literal goes through Double first, so the precision is already lost.
    print("From a floating-point literal:", Money(amount: 3.133, currency: .uah).amount)

    _ = try tenKopecks + Money(amount: 100, currency: .usd)
} catch {
    print("Addition failed:", error)
}
