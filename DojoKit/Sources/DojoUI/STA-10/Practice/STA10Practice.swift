// STA-10 · Master → Detail with optimistic updates · ⏱ 60 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. The list and the detail screen share one `ItemRepository` (`STA-05`).
// 2. A change in the detail screen is applied locally immediately, then sent to the server.
// 3. A server error rolls the change back and shows a message.
//
// Done when
// - [ ] A change in the detail screen shows up in the list without a manual refresh
// - [ ] The UI reacts to the change in < 16 ms (i.e. before the network call)
// - [ ] An error rolls state back exactly to the previous one — the test compares snapshots
// - [ ] Two quick consecutive changes don't leave the state "mixed"
//
// Pitfall
// Rolling back with two concurrent changes isn't "restore the previous value" — it's "reapply the last confirmed
// state". Keep `confirmed` and `pending` separate.
