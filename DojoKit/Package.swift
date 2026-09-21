// swift-tools-version: 6.0

import PackageDescription

// Every kata gets two isolated modules, so a half-finished attempt never breaks another kata's build:
//   Sources/<Group>/<ID>/Practice → <ID>Practice   your attempt, starts empty
//   Sources/<Group>/<ID>/Solution → <ID>Solution   reference solution

func katas(_ theme: String, _ numbers: ClosedRange<Int>) -> [String] {
    numbers.map { number in "\(theme)-\(number < 10 ? "0" : "")\(number)" }
}

func moduleName(_ id: String, _ variant: String) -> String {
    id.filter { $0 != "-" } + variant
}

let variants = ["Practice", "Solution"]

let groups: [(folder: String, katas: [String])] = [
    ("DojoCore", katas("MOD", 1...5) + katas("TYP", 1...7) + katas("STD", 1...8)
        + katas("GEN", 11...11) + katas("SEQ", 6...21) + katas("SOL", 1...9)),
    ("DojoNetworking", katas("COD", 1...6) + katas("SRV", 1...11) + katas("CNC", 1...8)),
    ("DojoUI", katas("STA", 1...11) + katas("UI", 1...5)),
    ("DojoUIKit", katas("HIT", 1...8) + katas("RSP", 1...6)),
]

// Testing katas are test targets themselves.
let testKatas = katas("TST", 1...3)

let sourceTargets = groups.flatMap { group in
    group.katas.flatMap { id in
        variants.map { variant -> Target in
            .target(name: moduleName(id, variant), path: "Sources/\(group.folder)/\(id)/\(variant)")
        }
    }
}

let testTargets = testKatas.flatMap { id in
    variants.map { variant -> Target in
        .testTarget(name: moduleName(id, variant), path: "Tests/\(id)/\(variant)")
    }
}

let package = Package(
    name: "DojoKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    targets: sourceTargets + testTargets
)
