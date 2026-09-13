// STA-02 · Pagination as a state machine · ⏱ 30 min — practice
// Task: TASKS-4-app.md
//
// Task
// 1.
//    `enum FeedState { case idle, loading, loaded([Item], hasMore: Bool), loadingMore([Item]), exhausted([Item]), failed(AppError, retry: [Item]) }`.
// 2. `enum FeedAction { case load, loadMore, received(Page<Item>), failed(AppError), retry }`.
// 3. A transition table in a test: for every (state, action) pair — the expected new state or "ignored".
//
// Done when
// - [ ] `loadMore` in `.loading` does nothing (doesn't start a second request)
// - [ ] `loadMore` in `.exhausted` does nothing
// - [ ] The transition table covers every combination — none marked "can't happen"
// - [ ] It's impossible to be in `loading` and `failed` at the same time
//
// Pitfall
// It's tempting to write `case loading(previousItems: [Item], isFirstLoad: Bool)` and start piling up flags. If a
// `Bool` shows up in the enum, check whether it should be a separate case.
