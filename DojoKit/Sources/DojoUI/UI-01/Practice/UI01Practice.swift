// UI-01 · Login screen · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `@Observable final class LoginViewModel` with `email`, `password`, `state`.
// 2. Live validation: the button is enabled only with a valid email and a password ≥ 8 characters.
// 3. State: `idle`, `submitting`, `failed(String)`; fields are disabled during `submitting`.
//
// Done when
// - [ ] The ViewModel is tested without rendering the View
// - [ ] The button is disabled when fields are empty, proven by a test on `canSubmit`
// - [ ] A repeated tap during `submitting` does nothing
// - [ ] The View has no `if email.contains("@")` — all logic lives in the VM
//
// Pitfall
// `@Observable` won't work if the VM is created as `let vm = LoginViewModel()` right inside `body`. You need
// `@State private var vm`.
