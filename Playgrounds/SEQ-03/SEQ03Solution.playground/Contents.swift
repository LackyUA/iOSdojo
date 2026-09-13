// SEQ-03 · `Stack<T>: Sequence` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// A last-in, first-out collection.
struct Stack<Element>: Sequence {

    init() {
        storage = []
    }

    /// Creates a stack and pushes the elements in order, so the last element is on top.
    init(_ elements: some Sequence<Element>) {
        storage = Array(elements)
    }

    var isEmpty: Bool {
        storage.isEmpty
    }

    mutating func push(_ element: Element) {
        storage.append(element)
    }

    /// Removes and returns the top element, or returns `nil` if the stack is empty.
    @discardableResult
    mutating func pop() -> Element? {
        storage.popLast()
    }

    /// Returns the top element without removing it, or returns `nil` if the stack is empty.
    func peek() -> Element? {
        storage.last
    }

    // MARK: - Sequence

    /// Returns an iterator that goes from the top of the stack to the bottom. The iteration doesn't change the stack.
    func makeIterator() -> ReversedCollection<[Element]>.Iterator {
        // `Array` is a `BidirectionalCollection`, so `reversed()` returns a `ReversedCollection`: a view that reads the
        // array from the end, without a copy. `Sequence.reversed()` would return a new array, but the more specific
        // overload wins. The explicit return type makes the compiler prove it.
        storage.reversed().makeIterator()
    }

    // MARK: - Private Properties

    /// The elements from the bottom to the top.
    private var storage: [Element]
}

// MARK: - Usage

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

precondition(Array(stack) == [3, 2, 1])
precondition(stack.peek() == 3)
precondition(Array(Stack([1, 2, 3])) == [3, 2, 1])

// These methods come from `Sequence` for free.
precondition(stack.contains(2))
precondition(stack.map { $0 * 10 } == [30, 20, 10])
precondition(stack.reduce(0, +) == 6)
precondition(stack.first { $0 < 3 } == 2)

// The `first` property belongs to `Collection`, not `Sequence`:
//
// let top: Int? = stack.first
//
// error: cannot convert value of type '((Int) throws -> Bool) throws -> Optional<Int>' to specified type 'Int'
//
// The compiler finds only the method `first(where:)`. Without a type annotation, `_ = stack.first` even compiles as a
// reference to that method. Use `peek()` for the top element.

// The iteration doesn't destroy the stack.
for element in stack {
    print(element)
}
precondition(Array(stack) == [3, 2, 1])

print(type(of: [1, 2, 3].reversed()))

precondition(stack.pop() == 3)
precondition(stack.pop() == 2)
precondition(stack.pop() == 1)
precondition(stack.pop() == nil)
precondition(stack.isEmpty)

print("All checks passed")
