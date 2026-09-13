// STA-04 · Undo/redo · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. `protocol Command { func execute(on state: inout TaskList); func undo(on state: inout TaskList) }`.
// 2. Three commands: `AddTask`, `RemoveTask`, `ToggleCompletion`.
// 3. `struct CommandHistory` with `undoStack`, `redoStack`, `perform(_:)`, `undo()`, `redo()`.
//
// Done when
// - [ ] The sequence add → toggle → remove → undo×3 restores exactly the initial state
// - [ ] `redo` after `undo` replays the action
// - [ ] A new action after `undo` clears `redoStack`
// - [ ] `RemoveTask.undo` puts the element back at the same position, not at the end
//
// Pitfall
// `RemoveTask` must remember both the element and its index during `execute`. That means the command holds mutable
// state — which is fine, but it should be a conscious choice.
