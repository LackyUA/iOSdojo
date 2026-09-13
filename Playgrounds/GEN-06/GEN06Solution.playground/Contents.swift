// GEN-06 · Sorting by `KeyPath` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

import Foundation

extension Sequence {

    /// Returns the elements sorted in ascending order of the value at the key path.
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath, order: .forward)
    }

    /// Returns the elements sorted in the given order of the value at the key path.
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>, order: SortOrder) -> [Element] {
        sorted { lhs, rhs in
            switch order {
            case .forward:
                lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
            case .reverse:
                lhs[keyPath: keyPath] > rhs[keyPath: keyPath]
            }
        }
    }

    /// Returns the elements sorted by the first key path, and then by the second key path.
    ///
    /// The sort is stable. Elements with equal values at both key paths keep their original order.
    func sorted<Primary: Comparable, Secondary: Comparable>(
        by primary: KeyPath<Element, Primary>,
        then secondary: KeyPath<Element, Secondary>,
    ) -> [Element] {
        sorted { lhs, rhs in
            let lhsPrimary = lhs[keyPath: primary]
            let rhsPrimary = rhs[keyPath: primary]
            guard lhsPrimary == rhsPrimary else {
                return lhsPrimary < rhsPrimary
            }
            return lhs[keyPath: secondary] < rhs[keyPath: secondary]
        }
    }
}

// MARK: - Usage

struct Person {
    let firstName: String
    let lastName: String
    let department: String
    let age: Int
}

let people = [
    Person(firstName: "Taras", lastName: "Shevchenko", department: "Sales", age: 47),
    Person(firstName: "Lesia", lastName: "Ukrainka", department: "Engineering", age: 42),
    Person(firstName: "Ivan", lastName: "Franko", department: "Sales", age: 60),
    Person(firstName: "Olha", lastName: "Kobylianska", department: "Engineering", age: 42),
    Person(firstName: "Mykola", lastName: "Franko", department: "Sales", age: 31),
]

print(people.sorted(by: \.age).map(\.firstName))
print(people.sorted(by: \.age, order: .reverse).map(\.firstName))

// Lesia and Olha have the same age. A stable sort keeps Lesia first, as in the input.
precondition(people.sorted(by: \.age).map(\.firstName) == ["Mykola", "Lesia", "Olha", "Taras", "Ivan"])

// Ivan and Mykola have the same department and last name, so they keep their input order.
let byDepartment = people.sorted(by: \.department, then: \.lastName)
print(byDepartment.map { "\($0.department) \($0.lastName) \($0.firstName)" })
precondition(byDepartment.map(\.firstName) == ["Olha", "Lesia", "Ivan", "Mykola", "Taras"])

// MARK: - Comparison with `sorted(using:)`

// Foundation already covers all three cases:
let foundationSorted = people.sorted(using: [KeyPathComparator(\.department), KeyPathComparator(\.lastName)])
precondition(foundationSorted.map(\.firstName) == byDepartment.map(\.firstName))

// Was it worth it? For one or two keys, `sorted(by: \.age)` is shorter and has no Foundation dependency.
// `sorted(using:)` wins for anything bigger: any number of keys, a direction per key, `String.StandardComparator`
// for localized order, and `SortDescriptor` for SwiftUI and SwiftData. In app code, prefer `sorted(using:)`
// unless the call sites are simple.
