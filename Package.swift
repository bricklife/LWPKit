// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LWPKit",
    products: [
        .library(
            name: "LWPKit",
            targets: ["LWPKit"]),
    ],
    targets: [
        .target(
            name: "LWPKit"),
        .testTarget(
            name: "LWPKitTests",
            dependencies: ["LWPKit"]),
    ]
)
