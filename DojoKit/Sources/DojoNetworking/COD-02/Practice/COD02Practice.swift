// COD-02 · DTO → Domain mapper · ⏱ 15 min — practice
// Task: TASKS-3-services.md
//
// Task
// 1. `UserDTO` (everything optional, strings instead of dates and enums) and `User` (nothing optional without a
//    reason).
// 2. `func map(_ dto: UserDTO) throws -> User` with an `enum MappingError` case for each missing required field.
// 3. Test: a DTO with `nil` in a required field produces a specific error, not `nil`.
//
// Done when
// - [ ] `User` has no optionals that were optional only "because that's what the backend sends"
// - [ ] The error names exactly which field is missing
// - [ ] The test for a "complete" DTO checks every field — none is forgotten in the mapping
//
// Pitfall
// A mapper that silently substitutes defaults (`dto.name ?? ""`) masks a backend problem. Either throw, or document the
// default as a business decision.
