// SEQ-14 · A tree with two traversals · ⏱ 30 min — practice
// Task: TASKS-2-generics-sequences.md
//
// Task
// 1. `struct Tree<Element> { let value: Element; let children: [Tree] }`.
// 2. `struct DepthFirstSequence<Element>: Sequence` and `struct BreadthFirstSequence<Element>: Sequence`.
// 3. On the tree — properties `var dfs: DepthFirstSequence<Element>` and `var bfs: BreadthFirstSequence<Element>`.
//
// Done when
// - [ ] `Array(tree.dfs)` and `Array(tree.bfs)` yield different orders on a tree of depth 3
// - [ ] Neither iterator uses recursion (only an explicit stack/queue)
// - [ ] `tree.dfs.first(where:)` finishes early, without traversing the whole tree
//
// Pitfall
// It's tempting to write `func traverse(order: TraversalOrder)` with an enum parameter. Then there's a `switch` inside
// and two implementations in one method. Separate types are OCP: a third traversal is added without changing the
// existing ones.
