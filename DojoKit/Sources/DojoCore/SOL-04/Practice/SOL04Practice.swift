// SOL-04 · DRY that shouldn't be fixed · ⏱ 15 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Find two similar blocks in your code (or write them: email validation at sign-up and when changing the email in
//    the profile).
// 2. Merge them in your head and list what happens when one of the requirements changes.
// 3. Write the decision in a comment: merge or not, and why.
//
// Done when
// - [ ] At least one scenario is described where merging causes a problem
// - [ ] The criterion is stated: "same code" ≠ "same reason to change"
// - [ ] The decision is made explicitly, not by default
//
// Pitfall
// The most expensive mistake is merging two blocks that are similar **by accident**. A year later an
// `if isRegistration` appears inside the shared function, and the real pain begins.
