// SOL-03 · Split a fat protocol · ⏱ 15 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Take `protocol UserService` with 8 methods (profile, avatar, settings, account deletion).
// 2. Find two clients, each using 2–3 methods.
// 3. Split it into `ProfileReading`, `AvatarUpdating`, `AccountDeleting`; one type conforms to all three.
//
// Done when
// - [ ] The mock for the profile test implements 2 methods, not 8
// - [ ] The real implementation didn't change — only conformances were added
// - [ ] Each client depends only on what it uses
// - [ ] No `UserServicing: ProfileReading & AvatarUpdating & AccountDeleting` protocol "for convenience"
//
// Pitfall
// ISP isn't measured by the number of methods in a protocol, but by the number of methods a specific client **doesn't
// need**. An 8-method protocol where every client needs all 8 is fine.
