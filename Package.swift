// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-css-standard",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        // Main umbrella product
        .library(
            name: "CSS Standard",
            targets: ["CSS Standard"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-w3c/swift-w3c-css.git", branch: "main"),
        .package(url: "https://github.com/swift-iec/swift-iec-61966.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-color-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main")
    ],
    targets: [
        // Main umbrella target - re-exports everything
        .target(
            name: "CSS Standard",
            dependencies: [
                .product(name: "W3C CSS", package: "swift-w3c-css"),
                .product(name: "IEC 61966", package: "swift-iec-61966"),
                .product(name: "Color Standard", package: "swift-color-standard"),
                .product(name: "Byte Primitives", package: "swift-byte-primitives")
            ]
        ),
        .testTarget(
            name: "CSS Standard Tests",
            dependencies: [
                "CSS Standard",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

// Apply Swift language features
for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
