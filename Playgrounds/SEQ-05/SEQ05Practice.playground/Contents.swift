// SEQ-05 · `underestimatedCount` · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Take `SEQ-02` or `SEQ-03` and add logging to `makeIterator` and `next`.
// 2. Run `Array(sequence)` and count how many times the storage was reallocated (via a `reserveCapacity` log or simply
//    by counting calls).
// 3. Implement `var underestimatedCount: Int` and measure again.
//
// Done when
// - [ ] The number of reallocations before and after is recorded as numbers
// - [ ] `underestimatedCount` is never greater than the real count
// - [ ] A comment lists what else uses this value (`Array.init`, `reserveCapacity`, `flatMap`)
//
// Pitfall
// If `underestimatedCount` overstates, you get either a crash or silently wrong behavior in the stdlib. The contract:
// "no more than the actual count".
