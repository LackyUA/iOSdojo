// SEQ-04 · `CountedSet` + literal · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// An unordered collection of elements, in which each element can occur more than once.
struct CountedSet<Element: Hashable>: Hashable, Sequence, ExpressibleByArrayLiteral {

    init() {
        storage = [:]
    }

    init(_ elements: some Sequence<Element>) {
        self.init()
        for element in elements {
            insert(element)
        }
    }

    /// The number of occurrences of all elements.
    private(set) var count = 0

    var isEmpty: Bool {
        storage.isEmpty
    }

    /// Returns the number of occurrences of the element.
    subscript(element: Element) -> Int {
        count(of: element)
    }

    /// Adds one occurrence of the element.
    mutating func insert(_ element: Element) {
        storage[element, default: 0] += 1
        count += 1
    }

    /// Removes one occurrence of the element.
    ///
    /// - Returns: The removed element, or `nil` if the set doesn't contain the element.
    @discardableResult
    mutating func remove(_ element: Element) -> Element? {
        guard let occurrences = storage[element] else {
            return nil
        }
        // A key with zero occurrences must not stay, or two equal sets could compare as different.
        storage[element] = occurrences > 1 ? occurrences - 1 : nil
        count -= 1
        return element
    }

    /// Returns the number of occurrences of the element.
    func count(of element: Element) -> Int {
        storage[element, default: 0]
    }

    // MARK: - ExpressibleByArrayLiteral

    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    // MARK: - Sequence

    /// An iterator that returns each element as many times as the element occurs.
    ///
    /// The order of elements is unspecified. Swift seeds hashing randomly in each process, so the order can change
    /// between two runs of the same code. Occurrences of the same element are always adjacent.
    struct Iterator: IteratorProtocol {

        init(storage: [Element: Int]) {
            base = storage.makeIterator()
        }

        // MARK: - IteratorProtocol

        mutating func next() -> Element? {
            if remainingOccurrences == 0 {
                guard let entry = base.next() else {
                    return nil
                }
                currentElement = entry.key
                remainingOccurrences = entry.value
            }
            remainingOccurrences -= 1
            return currentElement
        }

        // MARK: - Private Properties

        private var base: Dictionary<Element, Int>.Iterator
        private var currentElement: Element?
        private var remainingOccurrences = 0
    }

    var underestimatedCount: Int {
        count
    }

    func makeIterator() -> Iterator {
        Iterator(storage: storage)
    }

    // MARK: - Private Properties

    /// The number of occurrences by element. The storage never contains a zero count.
    private var storage: [Element: Int]
}

// MARK: - Usage

var bag: CountedSet = ["a", "a", "b"]

precondition(bag.count(of: "a") == 2)
precondition(bag["b"] == 1)
precondition(bag["c"] == 0)
precondition(bag.count == 3)
precondition(Array(bag).count == 3)

// The order can differ between runs, so don't compare the array directly. Sort it, or compare as a `CountedSet`.
print(Array(bag))
precondition(Array(bag).sorted() == ["a", "a", "b"])
precondition(CountedSet(Array(bag)) == bag)

// `contains` and `filter` come from `Sequence`.
precondition(bag.contains("b"))
precondition(bag.filter { $0 == "a" }.count == 2)

bag.remove("a")
precondition(bag["a"] == 1)
bag.remove("a")
precondition(bag == ["b"])
precondition(bag.remove("z") == nil)

print("All checks passed")
