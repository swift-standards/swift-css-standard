// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-css-standard",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // Main umbrella product
        .library(
            name: "CSS Standard",
            targets: ["CSS Standard"]
        )
    ],
    dependencies: [
        .package(path: "../swift-w3c-css"),
        .package(path: "../swift-iec-61966"),
        .package(path: "../swift-color-standard"),
    ],
    targets: [
        // Main umbrella target - re-exports everything
        .target(
            name: "CSS Standard",
            dependencies: [
                .product(name: "W3C CSS", package: "swift-w3c-css"),
                .product(name: "IEC 61966", package: "swift-iec-61966"),
                .product(name: "Color Standard", package: "swift-color-standard"),
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
