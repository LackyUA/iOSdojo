// STA-11 · Offline-first · ⏱ 60 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Writes always go to local storage (`SRV-09`) and to a sync queue.
// 2. `SyncEngine` flushes the queue when the network is available; the queue survives a relaunch.
// 3. A conflict (the server has a newer version) is resolved with one explicit strategy: last-write-wins or merge —
//    your choice, with a rationale.
//
// Done when
// - [ ] Three offline changes, then the network comes back → three calls in the correct order
// - [ ] Relaunching the app doesn't lose the queue
// - [ ] The conflict is reproduced in a test, and the result matches the documented strategy
// - [ ] Resending an already-applied change is idempotent (doesn't duplicate the record)
//
// Pitfall
// Idempotency isn't optional. Without a client-side operation ID, a network retry creates a duplicate, and the user
// will see it.
