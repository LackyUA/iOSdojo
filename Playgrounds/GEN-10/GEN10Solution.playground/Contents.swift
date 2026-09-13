// GEN-10 · Returning `some Collection` · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

struct Item {
    let name: String
    let isActive: Bool
}

// MARK: - Step 1: An array

// func activeItems(in items: [Item]) -> [Item] {
//     items.filter(\.isActive)
// }
//
// The function makes a new array each time, and the signature promises an array forever.

// MARK: - Step 2: An opaque collection

/// Returns the active items.
///
/// The collection filters lazily. It doesn't copy the items, and it checks `isActive` each time that you traverse it.
func activeItems(in items: [Item]) -> some Collection<Item> {
    items.lazy.filter(\.isActive)
}

// MARK: - Step 3: Call site

let items = [
    Item(name: "Milk", isActive: true),
    Item(name: "Bread", isActive: false),
    Item(name: "Coffee", isActive: true),
]

// A playground runs each top-level statement through LLDB, and LLDB can't keep a top-level variable of an opaque type.
// The `do` scope makes `result` a local variable.
do {
    let result = activeItems(in: items)

    // The static type is `some Collection<Item>`. Only a runtime check shows `LazyFilterSequence<Array<Item>>`.
    // `LazyFilterCollection` is a type alias of that type.
    print(type(of: result))

    print(result.count)
    print(result.map(\.name))
    print(result.first?.name ?? "none")

    let secondIndex = result.index(after: result.startIndex)
    print(result[secondIndex].name, "at index", secondIndex)

    // result.append(Item(name: "Tea", isActive: true))
    // error: value of type 'some Collection<Item>' has no member 'append'
    //
    // result[0]
    // error: no exact matches in call to subscript
    //
    // Indexing works, but only with the collection's own `Index`. `Collection` doesn't promise that `Index` is `Int`,
    // and `LazyFilterCollection` really uses the base array's index: the second active item is at index 2, not 1.
}

// MARK: - Changing the implementation

// Replace the body with `items.filter(\.isActive)`. The underlying type becomes `[Item]`, but every call site above
// still compiles, because the callers only know `some Collection<Item>`.

// MARK: - Pitfall: One underlying type

// func activeItems(in items: [Item], lazily: Bool) -> some Collection<Item> {
//     if lazily {
//         return items.lazy.filter(\.isActive)
//     }
//     return items.filter(\.isActive)
// }
//
// error: function declares an opaque return type 'some Collection<Item>', but the return statements in its body do
// not have matching underlying types
//
// `some` hides one concrete type, and the compiler must know it. To return different types, use `any Collection<Item>`
// or erase to an array.
