// GEN-05 · `AnyRepository<T>` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

enum RepositoryError: Error {
    case unavailable
}

protocol Repository: Sendable {

    associatedtype Model: Sendable

    /// Returns all models.
    func all() async throws(RepositoryError) -> [Model]

    /// Saves a model.
    func save(_ model: Model) async throws(RepositoryError)
}

// MARK: - Implementations

actor InMemoryRepository<Item: Sendable>: Repository {

    init(items: [Item] = []) {
        self.items = items
    }

    // MARK: - Repository

    func all() -> [Item] {
        items
    }

    func save(_ item: Item) {
        items.append(item)
    }

    // MARK: - Private Properties

    private var items: [Item]
}

/// A repository that hides the type of the repository that it wraps.
struct AnyRepository<Model: Sendable>: Repository {

    init<Base: Repository>(_ base: Base) where Base.Model == Model {
        self._all = { () async throws(RepositoryError) in
            try await base.all()
        }
        self._save = { model async throws(RepositoryError) in
            try await base.save(model)
        }
    }

    // MARK: - Repository

    func all() async throws(RepositoryError) -> [Model] {
        try await _all()
    }

    func save(_ model: Model) async throws(RepositoryError) {
        try await _save(model)
    }

    // MARK: - Private Properties

    // Without `@Sendable`, a non-Sendable closure makes `AnyRepository` non-Sendable in Swift 6.
    private let _all: @Sendable () async throws(RepositoryError) -> [Model]
    private let _save: @Sendable (Model) async throws(RepositoryError) -> Void
}

// MARK: - Service

struct Item: Sendable, Equatable {
    let name: String
}

/// Adds items and lists their names. The service doesn't know the concrete repository type.
actor ItemsService {

    init(repository: AnyRepository<Item>) {
        self.repository = repository
    }

    func add(name: String) async throws(RepositoryError) {
        try await repository.save(Item(name: name))
    }

    func names() async throws(RepositoryError) -> [String] {
        try await repository.all().map(\.name)
    }

    // MARK: - Private Properties

    private let repository: AnyRepository<Item>
}

// MARK: - Test Doubles

/// A fake that records saved items and fails on request.
actor FakeItemsRepository: Repository {

    private(set) var savedItems: [Item] = []

    func all() async throws(RepositoryError) -> [Item] {
        guard !isUnavailable else {
            throw .unavailable
        }
        return savedItems
    }

    func save(_ item: Item) async throws(RepositoryError) {
        guard !isUnavailable else {
            throw .unavailable
        }
        savedItems.append(item)
    }

    func setUnavailable() {
        isUnavailable = true
    }

    // MARK: - Private Properties

    private var isUnavailable = false
}

// MARK: - Usage

let production = ItemsService(repository: AnyRepository(InMemoryRepository(items: [Item(name: "Milk")])))
try await production.add(name: "Bread")
print(try await production.names())

// The test injects the fake. The service code doesn't change.
let fake = FakeItemsRepository()
let service = ItemsService(repository: AnyRepository(fake))

try await service.add(name: "Coffee")
let savedItems = await fake.savedItems
let names = try await service.names()
precondition(savedItems == [Item(name: "Coffee")])
precondition(names == ["Coffee"])

await fake.setUnavailable()
do {
    _ = try await service.names()
    preconditionFailure("The service must forward the repository error")
} catch {
    // The error is `RepositoryError`, not `any Error`, so the switch is exhaustive.
    switch error {
    case .unavailable:
        print("Forwarded:", error)
    }
}
