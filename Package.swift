// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-css-standard",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .macCatalyst(.v18)
    ],
    products: [
        // Main umbrella product
        .library(
            name: "CSS Standard",
            targets: ["CSS Standard"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-w3c-css", from: "0.1.0")
    ],
    targets: [
        // Main umbrella target - re-exports everything
        .target(
            name: "CSS Standard",
            dependencies: [
                .product(name: "W3C CSS", package: "swift-w3c-css")
            ]
        ),
        .testTarget(
            name: "CSS Standard Tests",
            dependencies: ["CSS Standard"]
        )
    ],
    swiftLanguageModes: [.v6]
)

// Apply Swift language features
for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
