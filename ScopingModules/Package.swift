// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScopingModules",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "ChildSceneA", targets: ["ChildSceneA"]),
        .library(name: "ChildSceneB", targets: ["ChildSceneB"]),
        .library(name: "RootScene", targets: ["RootScene"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMinor(from: "0.40.2")),
    ],
    targets: [
        .target(
            name: "ChildSceneA",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ChildSceneB",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "RootScene",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "ChildSceneA",
                "ChildSceneB",
            ]
        ),
    ]
)
