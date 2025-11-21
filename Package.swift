// swift-tools-version: 6.0

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
        ),
        // Compatibility products for gradual migration from swift-css-types
        .library(
            name: "CSS Standard Properties",
            targets: ["CSS Standard Properties"]
        ),
        .library(
            name: "CSS Standard AtRules",
            targets: ["CSS Standard AtRules"]
        )
    ],
    dependencies: [
        .package(path: "../swift-w3c-css")
    ],
    targets: [
        // Main umbrella target - re-exports everything
        .target(
            name: "CSS Standard",
            dependencies: [
                .product(name: "W3C CSS", package: "swift-w3c-css")
            ]
        ),

        // Compatibility target for CSS properties
        .target(
            name: "CSS Standard Properties",
            dependencies: [
                .product(name: "W3C CSS", package: "swift-w3c-css")
            ]
        ),

        // Compatibility target for CSS at-rules
        .target(
            name: "CSS Standard AtRules",
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
