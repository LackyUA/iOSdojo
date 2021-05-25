// Kata:
// Create stack using array as storage.

import Foundation

protocol Stacking {
    associatedtype Element
    
    var isEmpty: Bool { get }
    var peek: Element? { get }
    
    mutating func pop() -> Element?
    mutating func push(_ element: Element)
}

struct Stack<Element>: Stacking {
    
    // MARK: - Properties
    
    private var storage: [Element]
    
    // MARK: - Init
    
    init(_ elements: [Element] = []) {
        self.storage = elements
    }
    
    // MARK: - Behaviour
    
    var isEmpty: Bool {
        storage.isEmpty
    }
    
    var peek: Element? {
        storage.last
    }
    
    mutating func pop() -> Element? {
        storage.removeLast()
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
}
