// GEN-08 · A witness instead of a protocol · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

enum ValidationError: Error, Equatable {
    case empty
    case tooShort(minimumLength: Int)
    case invalidEmail
}

/// A validator as a value. It replaces the `Validator` protocol and `AnyValidator` from GEN-04.
struct ValidatorWitness<Input>: Sendable {

    /// Throws an error if the input is not valid.
    let validate: @Sendable (Input) throws(ValidationError) -> Void

    /// Returns a validator that passes only if this validator and `other` both pass.
    ///
    /// The validator stops at the first error.
    func and(_ other: Self) -> Self {
        Self { input throws(ValidationError) in
            try validate(input)
            try other.validate(input)
        }
    }

    /// Returns a validator of `Root` that validates the value at the key path.
    func pullback<Root>(_ keyPath: KeyPath<Root, Input> & Sendable) -> ValidatorWitness<Root> {
        ValidatorWitness<Root> { root throws(ValidationError) in
            try validate(root[keyPath: keyPath])
        }
    }
}

// MARK: - Factories

extension ValidatorWitness where Input == String {

    static var notEmpty: Self {
        Self { input throws(ValidationError) in
            guard !input.isEmpty else {
                throw .empty
            }
        }
    }

    static var emailFormat: Self {
        Self { input throws(ValidationError) in
            guard input.wholeMatch(of: #/[^@\s]+@[^@\s]+\.[^@\s]+/#) != nil else {
                throw .invalidEmail
            }
        }
    }

    static func minLength(_ minimumLength: Int) -> Self {
        Self { input throws(ValidationError) in
            guard input.count >= minimumLength else {
                throw .tooShort(minimumLength: minimumLength)
            }
        }
    }
}

// MARK: - Usage

struct SignUpForm {
    let email: String
    let password: String
}

let email: ValidatorWitness<String> = .notEmpty.and(.emailFormat)
let password: ValidatorWitness<String> = .notEmpty.and(.minLength(8))

// Two validators of `String` become one validator of `SignUpForm`. With the protocol, this needs a new type.
let form = email.pullback(\SignUpForm.email).and(password.pullback(\.password))

let forms = [
    SignUpForm(email: "olena@foofke.com.ua", password: "correct-horse"),
    SignUpForm(email: "olena@", password: "correct-horse"),
    SignUpForm(email: "olena@jookle.com.ua", password: "short"),
    SignUpForm(email: "", password: ""),
]

for signUp in forms {
    do {
        try form.validate(signUp)
        print(signUp.email, "valid")
    } catch {
        print(signUp.email, error)
    }
}

// MARK: - Comparison with GEN-04

// Lost:
// - Protocol extensions and default implementations. A shared helper must be a function on the struct.
// - `where` constraints. `func f<V: Validator>(_ v: V) where V.Input == String` has no witness equivalent, but
//   `ValidatorWitness<String>` is usually enough.
// - Conformance as a type. A validator can't also conform to `Equatable`, `Codable`, or `CustomStringConvertible`.
// - Stored configuration is hidden in a closure. You can't read `minimumLength` back from a witness.
//
// Gained:
// - No erasure. `[ValidatorWitness<String>]` just works, and there is one type instead of a protocol, an eraser,
//   and a struct for each rule.
// - Composition is a plain function: `and`, `pullback`, and anything else you can write for a struct.
// - New rules are values made on the spot, for example in a test, without a new type declaration.
