// SRV-08 · `RetryPolicy` · ⏱ 30 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `struct RetryPolicy { let maxAttempts: Int; let baseDelay: Duration; let jitter: ClosedRange<Double> }`.
// 2. `func delay(forAttempt n: Int, random: (ClosedRange<Double>) -> Double) -> Duration` — exponential, with jitter.
// 3. A test with a fixed `random` checks the exact values for 4 attempts.
//
// Done when
// - [ ] The test is deterministic: `random` is injected, not `Double.random`
// - [ ] Delays grow exponentially: roughly 1s, 2s, 4s, 8s
// - [ ] There's an upper bound (`maxDelay`), otherwise the 10th attempt would wait 17 minutes
// - [ ] The policy knows nothing about networking — only about numbers
//
// Pitfall
// Without jitter, every client retries at the same moment after a server outage — the "thundering herd". Jitter isn't
// an optimization, it's a necessity.
