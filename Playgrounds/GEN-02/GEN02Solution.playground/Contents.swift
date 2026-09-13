// GEN-02 · `firstDuplicate` · ⏱ 5 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// Returns the first element that occurs a second time in the sequence.
///
/// The function traverses the sequence one time. Complexity: O(n), where n is the length of the sequence.
func firstDuplicate<Element: Hashable>(in sequence: some Sequence<Element>) -> Element? {
    var seen = Set<Element>()
    return sequence.first { !seen.insert($0).inserted }
}

// MARK: - Usage

struct Product: Hashable {
    let sku: String
}

precondition(firstDuplicate(in: [3, 1, 4, 1, 5, 3]) == 1)
precondition(firstDuplicate(in: ["kyiv", "lviv", "odesa", "lviv"]) == "lviv")
precondition(firstDuplicate(in: [Product(sku: "A-1"), Product(sku: "B-2"), Product(sku: "A-1")]) == Product(sku: "A-1"))

// A `Set` can't contain duplicates, so the result is always `nil`.
precondition(firstDuplicate(in: Set([1, 2, 3])) == nil)

precondition(firstDuplicate(in: [Int]()) == nil)
precondition(firstDuplicate(in: [1, 2, 3]) == nil)

// The function stops at the first duplicate, so an infinite sequence is fine when it has one.
precondition(firstDuplicate(in: (1...).lazy.map { $0 % 7 }) == 1)

print("All checks passed")
