// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LWPKit",
    products: [
        .library(
            name: "LWPKit",
            targets: ["LWPKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "LWPKit",
            dependencies: []),
        .testTarget(
            name: "LWPKitTests",
            dependencies: ["LWPKit"]),
    ]
)
