// TST-02 · Fixtures from files · ⏱ 15 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1. Put 3 JSON files in `Tests/Resources` and configure `resources:` in `Package.swift`.
// 2. A `func fixture(_ name: String) throws -> Data` helper using `Bundle.module`.
// 3. Rewrite the mapper test from `COD-02` to use files instead of in-code strings.
//
// Done when
// - [ ] No JSON in the tests — only file names
// - [ ] The files are valid: you can open them in an editor and format them
// - [ ] A missing file produces a clear error, not `nil`
// - [ ] One of the files is a real (anonymized) backend response, not a made-up one
//
// Pitfall
// `Bundle.main` doesn't work in SwiftPM tests — you need `Bundle.module`, and it only exists if resources are declared
// in the manifest.
