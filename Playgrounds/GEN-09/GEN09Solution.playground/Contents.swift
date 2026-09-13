// GEN-09 · `where Self: Equatable` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// A type with a stable identifier. The name prevents a clash with `Identifiable` from the standard library.
protocol Identifiable2 {
    var id: String { get }
}

extension Identifiable2 where Self: Equatable {

    /// Returns a Boolean value that indicates whether both values have the same identifier.
    func isSame(as other: Self) -> Bool {
        id == other.id
    }

    /// Returns a Boolean value that indicates whether this value is a changed copy of `other`.
    ///
    /// The values have the same identifier but different contents. Only an `Equatable` type can compare contents.
    func isModifiedVersion(of other: Self) -> Bool {
        isSame(as: other) && self != other
    }
}

// MARK: - Types

struct Product: Identifiable2, Equatable {
    let id: String
    let price: Int
}

/// A session isn't `Equatable`, so it doesn't get the methods from the constrained extension.
final class Session: Identifiable2 {

    init(id: String) {
        self.id = id
    }

    let id: String
}

// MARK: - Usage

let product = Product(id: "sku-1", price: 100)
let discounted = Product(id: "sku-1", price: 80)

print(product.isSame(as: discounted))
print(product.isModifiedVersion(of: discounted))
print(product.isModifiedVersion(of: product))

let session = Session(id: "session-1")
print(session.id)

// _ = session.isSame(as: session)
//
// error: referencing instance method 'isSame(as:)' on 'Identifiable2' requires that 'Session' conform to 'Equatable'
//
// Autocomplete on `product.` shows `id`, `isSame(as:)`, and `isModifiedVersion(of:)`. On `session.` it shows only `id`.

// `where Self: Equatable` vs `protocol Identifiable2: Equatable`:
// - The constrained extension adds methods only to conformers that are already `Equatable`. `Session` still conforms.
// - Protocol inheritance forces every conformer to be `Equatable`. `Session` would need `==`, and `Identifiable2`
//   would get a `Self` requirement, so `[any Identifiable2]` could no longer compare its elements.
