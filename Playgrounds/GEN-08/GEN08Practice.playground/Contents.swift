// GEN-08 · A witness instead of a protocol · ⏱ 15 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. Take `Validator` from `GEN-04`.
// 2. Replace the protocol with `struct ValidatorWitness<Input> { let validate: (Input) throws -> Void }`.
// 3. Add static factories: `static var notEmpty: ValidatorWitness<String>`,
//    `static func minLength(_ n: Int) -> ValidatorWitness<String>`.
//
// Done when
// - [ ] No protocol and no erasure wrapper — just one struct
// - [ ] Combining two validators is a function that returns a third
// - [ ] A comment compares this with `GEN-04`: what you lost, what you gained
//
// Pitfall
// You lose: protocol extensions, default implementations, `where` constraints. You gain: no erasure at all, composition
// as a plain function.
