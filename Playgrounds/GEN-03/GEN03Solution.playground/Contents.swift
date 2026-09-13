// GEN-03 · `Cache<Key, Value>` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

/// A cache that keeps at most `limit` values and evicts a value when it is full.
///
/// All operations take O(1) time. The cache is not thread-safe.
final class Cache<Key: Hashable, Value> {

    enum EvictionPolicy {

        /// Evicts the value that was inserted first.
        case firstInFirstOut

        /// Evicts the value that was read or written least recently.
        case leastRecentlyUsed
    }

    init(limit: Int, evictionPolicy: EvictionPolicy = .firstInFirstOut) {
        precondition(limit > 0, "The cache limit must be positive")
        self.limit = limit
        self.evictionPolicy = evictionPolicy
    }

    let limit: Int
    let evictionPolicy: EvictionPolicy

    var count: Int {
        nodes.count
    }

    subscript(key: Key) -> Value? {
        get {
            guard let node = nodes[key] else {
                return nil
            }
            if evictionPolicy == .leastRecentlyUsed {
                moveToNewest(node)
            }
            return node.value
        }
        set {
            guard let newValue else {
                removeValue(forKey: key)
                return
            }
            updateValue(newValue, forKey: key)
        }
    }

    // MARK: - Private Properties

    /// The nodes by key. The same nodes form a doubly linked list that sets the eviction order.
    private var nodes: [Key: Node] = [:]

    /// The node that is evicted next.
    private var oldest: Node?

    /// The node that was inserted, or used, last.
    private var newest: Node?

    // MARK: - Private Methods

    private func updateValue(_ value: Value, forKey key: Key) {
        if let node = nodes[key] {
            node.value = value
            if evictionPolicy == .leastRecentlyUsed {
                moveToNewest(node)
            }
            return
        }
        if nodes.count == limit, let oldest {
            removeValue(forKey: oldest.key)
        }
        let node = Node(key: key, value: value)
        nodes[key] = node
        append(node)
    }

    private func removeValue(forKey key: Key) {
        guard let node = nodes.removeValue(forKey: key) else {
            return
        }
        unlink(node)
    }

    private func moveToNewest(_ node: Node) {
        guard node !== newest else {
            return
        }
        unlink(node)
        append(node)
    }

    private func append(_ node: Node) {
        node.older = newest
        newest?.newer = node
        newest = node
        if oldest == nil {
            oldest = node
        }
    }

    private func unlink(_ node: Node) {
        node.older?.newer = node.newer
        node.newer?.older = node.older
        if node === oldest {
            oldest = node.newer
        }
        if node === newest {
            newest = node.older
        }
        node.older = nil
        node.newer = nil
    }
}

// MARK: - Node

extension Cache {

    private final class Node {

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }

        let key: Key
        var value: Value

        /// The next node toward the newest node. The list owns its nodes through this reference.
        var newer: Node?

        /// The next node toward the oldest node. The reference is weak to prevent a retain cycle.
        weak var older: Node?
    }
}

// MARK: - Usage

struct User {}

// swiftlint:disable type_name

/// An identifier that the compiler can't mix up with an identifier of another entity.
///
/// `Hashable` is synthesized even though `Tag` isn't `Hashable`, because `Tag` isn't stored.
struct ID<Tag>: Hashable {
    let rawValue: String
}

// swiftlint:enable type_name

// FIFO: after 101 inserts, the first key is gone.
let fifo = Cache<String, Int>(limit: 100)
for index in 0...100 {
    fifo["key-\(index)"] = index
}
precondition(fifo.count == 100)
precondition(fifo["key-0"] == nil)
precondition(fifo["key-1"] == 1)
precondition(fifo["key-100"] == 100)

// LRU: reading a value protects it, so the next oldest value is evicted instead.
let users = Cache<ID<User>, String>(limit: 2, evictionPolicy: .leastRecentlyUsed)
users[ID(rawValue: "1")] = "Olena"
users[ID(rawValue: "2")] = "Taras"
_ = users[ID(rawValue: "1")]
users[ID(rawValue: "3")] = "Iryna"
precondition(users[ID(rawValue: "1")] == "Olena")
precondition(users[ID(rawValue: "2")] == nil)
precondition(users.count == 2)

// Assigning `nil` removes a value and frees a place.
users[ID(rawValue: "1")] = nil
users[ID(rawValue: "4")] = "Mykola"
precondition(users[ID(rawValue: "3")] == "Iryna")
precondition(users.count == 2)

print("All checks passed")
