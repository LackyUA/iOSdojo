// Kata:
// Create property wrapper for Capitalizing Text.

import Foundation

@propertyWrapper
struct Capitalized {

    // MARK: - Properties

    private var value: String

    // MARK: - Computed properties

    var wrappedValue: String {
        get {
            value
        }
        set {
            value = newValue.capitalized
        }
    }

    // MARK: - Lifecycle

    init(wrappedValue: String) {
        value = wrappedValue.capitalized
    }

}

struct Person: CustomDebugStringConvertible {

    // MARK: - Properties

    @Capitalized var name: String
    @Capitalized var jobTitle: String

    // MARK: - CustomDebugStringConvertible

    var debugDescription: String {
        "Name: \(name) \nJob title: \(jobTitle)"
    }

}

let person = Person(name: "jhon pobelter", jobTitle: "developer")
print(person)
