// GEN-04 · `AnyValidator` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

enum ValidationError: Error, Equatable {
    case empty
    case tooShort(minimumLength: Int)
    case invalidEmail
}

protocol Validator: Sendable {

    associatedtype Input

    /// Throws an error if the input is not valid.
    func validate(_ input: Input) throws(ValidationError)
}

// MARK: - Validators

struct NotEmpty: Validator {

    func validate(_ input: String) throws(ValidationError) {
        guard !input.isEmpty else {
            throw .empty
        }
    }
}

struct MinLength: Validator {

    init(_ minimumLength: Int) {
        self.minimumLength = minimumLength
    }

    let minimumLength: Int

    func validate(_ input: String) throws(ValidationError) {
        guard input.count >= minimumLength else {
            throw .tooShort(minimumLength: minimumLength)
        }
    }
}

struct EmailFormat: Validator {

    func validate(_ input: String) throws(ValidationError) {
        guard input.wholeMatch(of: #/[^@\s]+@[^@\s]+\.[^@\s]+/#) != nil else {
            throw .invalidEmail
        }
    }
}

// MARK: - Step 2: A protocol in an array

// let validators: [Validator] = [NotEmpty(), MinLength(8), EmailFormat()]
//
// warning: use of protocol 'Validator' as a type must be written 'any Validator'; this will be an error in a future
// Swift language mode
//
// `[any Validator]` compiles, but the array is useless:
//
// for validator in validators {
//     try validator.validate("user@maudau.com.ua")
// }
//
// error: member 'validate' cannot be used on value of type 'any Validator'; consider using a generic constraint
// instead
//
// The box erases `Input`, so the compiler doesn't know which argument type `validate` accepts.
//
// A primary associated type is the modern alternative: with `protocol Validator<Input>`, the type
// `[any Validator<String>]` keeps `Input` and can call `validate`. A hand-written eraser is still useful when a
// concrete type is necessary, or when the erased value must add behavior.

// MARK: - Step 3: Type erasure

/// A validator that hides the type of the validator that it wraps.
///
/// Only the concrete validator type is erased. `Input` stays a generic parameter, so `validate` stays type-safe.
struct AnyValidator<Input>: Validator {

    init<Base: Validator>(_ base: Base) where Base.Input == Input {
        self._validate = { input throws(ValidationError) in
            try base.validate(input)
        }
    }

    init(_ validate: @escaping @Sendable (Input) throws(ValidationError) -> Void) {
        self._validate = validate
    }

    // MARK: - Validator

    func validate(_ input: Input) throws(ValidationError) {
        try _validate(input)
    }

    // MARK: - Private Properties

    private let _validate: @Sendable (Input) throws(ValidationError) -> Void
}

extension Validator {

    func eraseToAnyValidator() -> AnyValidator<Input> {
        AnyValidator(self)
    }
}

// MARK: - Usage

let validators: [AnyValidator<String>] = [
    AnyValidator(NotEmpty()),
    AnyValidator(MinLength(8)),
    EmailFormat().eraseToAnyValidator(),
    AnyValidator { input throws(ValidationError) in
        guard input.hasSuffix(".ua") else {
            throw .invalidEmail
        }
    },
]

for input in ["", "a@b.ua", "olena@google.com", "olena@foofle.com.ua"] {
    var errors: [ValidationError] = []
    for validator in validators {
        do {
            try validator.validate(input)
        } catch {
            errors.append(error)
        }
    }
    print("\"\(input)\":", errors.isEmpty ? "valid" : "\(errors)")
}
