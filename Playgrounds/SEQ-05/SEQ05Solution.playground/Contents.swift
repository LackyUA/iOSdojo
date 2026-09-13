// SEQ-05 · `underestimatedCount` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// The stack from SEQ-03, reduced to what this kata needs.
struct Stack<Element>: Sequence {

    init(_ elements: some Sequence<Element>) {
        storage = Array(elements)
    }

    // MARK: - Sequence

    /// The exact number of elements. The stack knows it without an iteration, so the value costs O(1).
    var underestimatedCount: Int {
        storage.count
    }

    func makeIterator() -> ReversedCollection<[Element]>.Iterator {
        storage.reversed().makeIterator()
    }

    // MARK: - Private Properties

    private var storage: [Element]
}

// MARK: - Logging

/// The calls that a `LoggingSequence` received.
final class CallLog {
    var makeIteratorCalls = 0
    var nextCalls = 0
    var underestimatedCountCalls = 0
}

/// A sequence that records the calls to the sequence that it wraps.
struct LoggingSequence<Base: Sequence>: Sequence {

    /// - Parameter reportsUnderestimatedCount: If `false`, the sequence reports 0, which is the default value of
    ///   `underestimatedCount` for a `Sequence`.
    init(_ base: Base, log: CallLog, reportsUnderestimatedCount: Bool) {
        self.base = base
        self.log = log
        self.reportsUnderestimatedCount = reportsUnderestimatedCount
    }

    // MARK: - Sequence

    var underestimatedCount: Int {
        log.underestimatedCountCalls += 1
        return reportsUnderestimatedCount ? base.underestimatedCount : 0
    }

    func makeIterator() -> Iterator {
        log.makeIteratorCalls += 1
        print("makeIterator()")
        return Iterator(base: base.makeIterator(), log: log)
    }

    struct Iterator: IteratorProtocol {

        init(base: Base.Iterator, log: CallLog) {
            self.base = base
            self.log = log
        }

        // MARK: - IteratorProtocol

        mutating func next() -> Base.Element? {
            log.nextCalls += 1
            return base.next()
        }

        // MARK: - Private Properties

        private var base: Base.Iterator
        private let log: CallLog
    }

    // MARK: - Private Properties

    private let base: Base
    private let log: CallLog
    private let reportsUnderestimatedCount: Bool
}

// MARK: - Measurement

/// Copies a sequence into an array the same way as `Array.init(_:)`, and counts the storage allocations.
///
/// `Array.init(_:)` reserves `underestimatedCount` places first. Then it appends the remaining elements, and it
/// allocates storage of double the size each time the storage is full.
func copyCountingAllocations<S: Sequence>(_ sequence: S) -> (elements: [S.Element], allocations: Int) {
    var elements: [S.Element] = []
    let reservedCount = sequence.underestimatedCount
    elements.reserveCapacity(reservedCount)
    var allocations = reservedCount > 0 ? 1 : 0
    for element in sequence {
        if elements.count == elements.capacity {
            allocations += 1
        }
        elements.append(element)
    }
    return (elements, allocations)
}

let elementCount = 1000
let stack = Stack(1...elementCount)

for reportsUnderestimatedCount in [false, true] {
    let log = CallLog()
    let sequence = LoggingSequence(stack, log: log, reportsUnderestimatedCount: reportsUnderestimatedCount)

    let copy = copyCountingAllocations(sequence)
    let array = Array(sequence)
    precondition(copy.elements == array)

    print(
        "underestimatedCount = \(sequence.underestimatedCount):",
        "\(copy.allocations) allocations,",
        "Array capacity \(array.capacity),",
        "\(log.makeIteratorCalls) makeIterator, \(log.nextCalls) next,",
        "\(log.underestimatedCountCalls) underestimatedCount",
    )
}

// The contract: `underestimatedCount` is never greater than the real count.
precondition(stack.underestimatedCount <= Array(stack).count)

// Measured with 1,000 elements. The call counts cover `copyCountingAllocations`, `Array.init`, and `print`:
//
// | underestimatedCount | Allocations | Array capacity | makeIterator | next  | underestimatedCount calls |
// |---------------------|-------------|----------------|--------------|-------|---------------------------|
// | 0 (default)         | 10          | 1276           | 2            | 2002  | 3                         |
// | 1000                | 1           | 1020           | 2            | 2002  | 3                         |
//
// Without the value, the array starts empty and grows by doubling. It allocates 10 times and ends with 276 unused
// places. With the value, one allocation is enough. The capacity is 1020, not 1000, because `Array` uses the full
// memory block that it gets. The number of `next` calls doesn't change: each copy makes 1,000 calls that return an
// element and one call that returns `nil`.

// MARK: - Users of `underestimatedCount`

// - `Array.init(_:)` and `ContiguousArray.init(_:)` reserve the value, and copy that many elements without a check.
// - `Sequence.map` reserves the value for its result, and transforms that many elements without a check.
// - `append(contentsOf:)` reserves `count + underestimatedCount` places before it appends.
// - `Sequence.flatMap` appends each segment with `append(contentsOf:)`, so each segment's value sets the growth.
// - Any code can call `reserveCapacity(sequence.underestimatedCount)` itself, as `copyCountingAllocations` does.

// MARK: - Pitfall: An overstated value

// struct Overstated: Sequence, IteratorProtocol {
//     var remaining = 3
//     var underestimatedCount: Int { 10 }
//
//     mutating func next() -> Int? {
//         guard remaining > 0 else {
//             return nil
//         }
//         remaining -= 1
//         return remaining
//     }
// }
//
// Array(Overstated())
// Swift/ContiguousArrayBuffer.swift:1089: Fatal error: Unexpectedly found nil while unwrapping an Optional value
//
// `Overstated().map { $0 }` crashes with the same message. Both trust the value and force-unwrap `next()` for the
// first 10 elements. In a Release build, the message is removed and the app only stops.
