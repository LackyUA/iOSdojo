// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

// Every kata gets isolated Practice and Solution modules, so a half-finished attempt never breaks another kata's build:
//   Sources/Dojo/<ID>/<Variant>       → <ID><Variant>         public macro declarations
//   Sources/DojoMacros/<ID>/<Variant> → <ID><Variant>Macros   SwiftSyntax implementation

func katas(_ theme: String, _ numbers: ClosedRange<Int>) -> [String] {
    numbers.map { number in "\(theme)-\(number < 10 ? "0" : "")\(number)" }
}

func moduleName(_ id: String, _ variant: String) -> String {
    id.filter { $0 != "-" } + variant
}

let variants = ["Practice", "Solution"]

// Exploration: no macro of your own, just a module to expand Apple's macros in.
let explorationKatas = katas("MAC", 1...3)
let macroKatas = katas("MAC", 4...11) + katas("MAC", 13...17)
// MAC-12 is about expansion tests.
let testKatas = katas("MAC", 12...12)

let explorationTargets = explorationKatas.flatMap { id in
    variants.map { variant -> Target in
        .target(name: moduleName(id, variant), path: "Sources/Dojo/\(id)/\(variant)")
    }
}

let macroTargets = macroKatas.flatMap { id in
    variants.flatMap { variant -> [Target] in
        let module = moduleName(id, variant)
        return [
            .macro(
                name: module + "Macros",
                dependencies: [
                    .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                    .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                ],
                path: "Sources/DojoMacros/\(id)/\(variant)"
            ),
            .target(
                name: module,
                dependencies: [.target(name: module + "Macros")],
                path: "Sources/Dojo/\(id)/\(variant)"
            ),
        ]
    }
}

let testTargets = testKatas.flatMap { id in
    variants.map { variant -> Target in
        .testTarget(
            name: moduleName(id, variant),
            dependencies: [
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "Tests/DojoMacrosTests/\(id)/\(variant)"
        )
    }
}

let package = Package(
    name: "DojoMacros",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0-latest"),
    ],
    targets: explorationTargets + macroTargets + testTargets
)
