// SOL-06 · Three functions → one · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Write three nearly identical functions: `fetchUsers`, `fetchOrders`, `fetchProducts` — differing only in URL and
//    response type.
// 2. Merge them into a generic (effectively `SRV-04`).
// 3. Then complicate it: `fetchOrders` needs its own pagination handling. Decide whether to keep it in the shared
//    function.
//
// Done when
// - [ ] The three functions are reduced to one
// - [ ] After the complication, an explicit decision is made and the rationale written down
// - [ ] If an `isPaginated: Bool` parameter was added, a comment explains why that's acceptable (or why not)
//
// Pitfall
// This kata is about the boundary. A generic with 6 configuration parameters is worse than three simple functions. You
// need a feel for the moment an abstraction becomes more expensive than duplication.
