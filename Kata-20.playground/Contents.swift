// Kata:
// Create stack using array as storage.

import Foundation

protocol Stacking {
    associatedtype Element
    
    var isEmpty: Bool { get }
    var peak: Element? { get }
    
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
        peak == nil
    }
    
    var peak: Element? {
        storage.last
    }

    @discardableResult
    mutating func pop() -> Element? {
        storage.removeLast()
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
}

var namesStack = Stack<String>()

print(namesStack.isEmpty ? "No values :(" : "There are some values in stack :)")

namesStack.push("Dmytro")
namesStack.push("Vlad")
namesStack.push("Oleksii")

print("Peak:", namesStack.peak ?? "Empty")

namesStack.pop()
namesStack.pop()

print("Popped:", namesStack.pop() ?? "Empty")
print(namesStack.isEmpty ? "No values :(" : "There are some values in stack :)")
