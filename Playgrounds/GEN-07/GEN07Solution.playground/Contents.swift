// GEN-07 · The cost of an existential · ⏱ 15 min — reference solution
// Task: TASKS-2-generics-sequences.md

protocol Shape {
    var area: Double { get }
}

struct Circle: Shape {
    let radius: Double

    var area: Double {
        .pi * radius * radius
    }
}

struct Square: Shape {
    let side: Double

    var area: Double {
        side * side
    }
}

struct Rectangle: Shape {
    let width: Double
    let height: Double

    var area: Double {
        width * height
    }
}

// MARK: - Two Versions

/// Sums the areas of shapes that all have the same type.
///
/// The compiler can specialize the function for `T`, so `area` is a direct call that can be inlined.
func totalArea<T: Shape>(_ shapes: [T]) -> Double {
    shapes.reduce(0) { $0 + $1.area }
}

/// Sums the areas of shapes of any types.
///
/// Each element is a box. Each `area` call goes through the witness table of the value in the box.
func totalArea(_ shapes: [any Shape]) -> Double {
    shapes.reduce(0) { $0 + $1.area }
}

// The generic version doesn't accept `[Circle(radius: 1), Square(side: 1)]`. `T` is one concrete type for the whole
// array, and a circle and a square have no common concrete type. Only `[any Shape]` can mix them.

// MARK: - Measurement

let count = 100_000
let iterations = 100

let circles = (0..<count).map { Circle(radius: Double($0 % 10)) }
let boxedCircles: [any Shape] = circles
let mixedShapes: [any Shape] = (0..<count).map { index -> any Shape in
    switch index % 3 {
    case 0:
        Circle(radius: Double(index % 10))
    case 1:
        Square(side: Double(index % 10))
    default:
        Rectangle(width: Double(index % 10), height: 2)
    }
}

precondition(totalArea(circles) == totalArea(boxedCircles))

func measure(_ label: String, _ body: () -> Double) {
    var result = 0.0
    let duration = ContinuousClock().measure {
        for _ in 0..<iterations {
            result = body()
        }
    }
    print(label, duration / iterations, "per call, result:", result)
}

measure("Generic, [Circle]:        ") { totalArea(circles) }
measure("Existential, [any Shape]: ") { totalArea(boxedCircles) }
measure("Existential, mixed:       ") { totalArea(mixedShapes) }

print("Size of Circle:", MemoryLayout<Circle>.size, "bytes. Size of any Shape:", MemoryLayout<any Shape>.size, "bytes")

// Measured on an Apple M3 Max, Swift 6.3, 100,000 elements, mean of 100 calls, three runs:
//
// | Configuration              | Generic  | Existential   | Existential, mixed |
// |----------------------------|----------|---------------|--------------------|
// | Release (`swiftc -O`)      | ~0.07 ms | ~0.33–0.43 ms | ~0.54 ms           |
// | Debug (`swiftc -Onone`)    | ~6.4 ms  | ~6.9 ms       | ~7.7 ms            |
//
// In Release, the existential version is about 5 times slower on the same circles. The generic version reads
// 8-byte values in a contiguous array and inlines `area`. The existential version reads 40-byte boxes and makes an
// indirect call for each element. Mixed types are slower again, because the call target changes on each element.
// In Debug, the missing optimizations cost much more than the boxes, so the difference is less than 10 percent.
// A playground runs without optimizations, so measure with `swiftc -O Contents.swift -o gen07 && ./gen07`.
