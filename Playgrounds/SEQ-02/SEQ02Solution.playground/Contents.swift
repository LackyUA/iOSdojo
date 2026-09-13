// SEQ-02 · A page iterator · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

// The task names the generic parameter `Element`. That compiles, but inside the type `Element` would mean one item,
// while `Sequence.Element` means one page. `Item` gives each concept its own name.

/// An iterator that returns the elements of an array in pages of equal size. The last page can be smaller.
struct PagedIterator<Item>: IteratorProtocol {

    init(elements: [Item], pageSize: Int) {
        self.elements = elements
        self.pageSize = pageSize
    }

    // MARK: - IteratorProtocol

    mutating func next() -> [Item]? {
        guard offset < elements.endIndex else {
            return nil
        }
        // `limitedBy` stops at the end of the array, and it doesn't overflow for a very large page size.
        let pageEnd = elements.index(offset, offsetBy: pageSize, limitedBy: elements.endIndex) ?? elements.endIndex
        defer {
            offset = pageEnd
        }
        return Array(elements[offset..<pageEnd])
    }

    // MARK: - Private Properties

    private let elements: [Item]
    private let pageSize: Int

    /// The index of the first element of the next page. The iterator changes only this index, never the elements.
    private var offset = 0
}

/// A sequence that returns the elements of an array in pages.
///
/// The iteration is repeatable. The sequence is a value, and each iterator reads the array without changing it, so
/// each pass returns the same pages.
struct PagedSequence<Item>: Sequence {

    /// - Precondition: `pageSize` is greater than zero.
    init(elements: [Item], pageSize: Int) {
        precondition(pageSize > 0, "The page size must be greater than zero, but it is \(pageSize)")
        self.elements = elements
        self.pageSize = pageSize
    }

    let elements: [Item]
    let pageSize: Int

    // MARK: - Sequence

    func makeIterator() -> PagedIterator<Item> {
        PagedIterator(elements: elements, pageSize: pageSize)
    }
}

// MARK: - Usage

let pages = PagedSequence(elements: Array(1...10), pageSize: 3)

var pageCount = 0
for page in pages {
    print(page)
    pageCount += 1
}
precondition(pageCount == 4)
precondition(Array(pages) == [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]])

// A second pass returns the same pages.
let firstPass = Array(pages)
let secondPass = Array(pages)
precondition(firstPass == secondPass)
precondition(pages.map(\.count) == [3, 3, 3, 1])

precondition(Array(PagedSequence(elements: [Int](), pageSize: 3)).isEmpty)
precondition(Array(PagedSequence(elements: [1, 2, 3], pageSize: 3)) == [[1, 2, 3]])
precondition(Array(PagedSequence(elements: [1, 2], pageSize: .max)) == [[1, 2]])

print("All checks passed")

// MARK: - Invalid page size

// PagedSequence(elements: [1, 2, 3], pageSize: 0)
// Precondition failed: The page size must be greater than zero, but it is 0
//
// A page size that isn't positive is a programmer error, so the initializer stops the app on purpose. Without the
// check, a page size of 0 makes an endless sequence of empty pages, and a negative page size crashes later on an
// invalid range. The check reports both mistakes at the call site that made them.

// MARK: - Pitfall: A destructive iterator

// `Sequence` doesn't promise that a second pass works. If an iterator removed pages from shared storage, for example
// from an array in a class, the first pass would empty it, and the second pass would return no pages.
