// SEQ-01 · `Sequence` via `AnyIterator` · ⏱ 5 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// Returns the Fibonacci numbers, starting from 0.
///
/// The sequence computes each number on demand. It ends after F(92) = 7,540,113,804,746,346,429, the largest Fibonacci
/// number that `Int` can hold.
func fibonacci() -> some Sequence<Int> {
    // The state lives in the closure. `nil` means that the number doesn't fit into `Int`.
    var current: Int? = 0
    var upcoming: Int? = 1
    return AnyIterator {
        guard let value = current else {
            return nil
        }
        current = upcoming
        upcoming = upcoming.flatMap { upcoming in
            let (sum, didOverflow) = value.addingReportingOverflow(upcoming)
            return didOverflow ? nil : sum
        }
        return value
    }
}

// MARK: - Usage

// A playground can't keep a top-level variable of an opaque type, so each expression makes its own sequence.
print(Array(fibonacci().prefix(10)))
precondition(Array(fibonacci().prefix(10)) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34])

// `first(where:)` stops at the first match. The counter shows how many numbers the sequence computed.
do {
    var computedCount = 0
    let firstAboveThousand = fibonacci()
        .lazy
        .map { number in
            computedCount += 1
            return number
        }
        .first { $0 > 1000 }
    print(firstAboveThousand ?? 0, "after", computedCount, "numbers")
    precondition(firstAboveThousand == 1597)
    precondition(computedCount == 18)
}

// `AnyIterator` is its own iterator. Two passes over the same sequence share the closure state, so the second pass
// continues where the first pass stopped. A new call to `fibonacci()` starts from 0 again.
do {
    let numbers = fibonacci()
    precondition(Array(numbers.prefix(3)) == [0, 1, 1])
    precondition(Array(numbers.prefix(3)) == [2, 3, 5])
}

// MARK: - `for in` without `prefix`

// for number in fibonacci() {
//     print(number)
// }
//
// The loop ends only when the iterator returns `nil`. A truly infinite sequence never does, so the loop never ends,
// and that is expected. `Int` makes this sequence finite: the loop prints 93 numbers and stops. Without the overflow
// check, the loop would crash on integer overflow instead.
precondition(Array(fibonacci()).count == 93)

// MARK: - Pitfall: Eager `map`

// `Sequence.map` is eager. It transforms all elements into an array before `prefix` runs, so on an infinite sequence
// it never returns. Here `fibonacci().map { $0 * 2 }.prefix(5)` crashes, because it doubles F(92) too.
// `lazy.map` transforms only the elements that `prefix` requests.
print(Array(fibonacci().lazy.map { $0 * 2 }.prefix(5)))
