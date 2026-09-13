// SRV-01 · `DateProviding` · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `protocol DateProviding { var now: Date { get } }`, `struct SystemDateProvider` and `struct FixedDateProvider`.
// 2. Take any type that uses `Date()` internally and inject the provider via init.
// 3. Write a test for "the subscription expired yesterday" logic without a single `sleep`.
//
// Done when
// - [ ] `grep "Date()"` over domain code returns 0 results
// - [ ] The test is deterministic — a run in January and in July gives the same result
// - [ ] A default init parameter value means production code doesn't have to pass the provider
//
// Pitfall
// Don't forget the time zone and calendar — `Calendar.current` in a test is just as unstable as `Date()`. Inject it
// too.
