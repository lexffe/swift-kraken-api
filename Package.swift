// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KrakenAPI",
    products: [
        .library(
            name: "KrakenAPI",
            targets: ["KrakenAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream", from: "4.0.0"),
        .package(name: "Promises", url: "https://github.com/google/promises.git", from: "1.2.8")
    ],
    targets: [
        .target(
            name: "KrakenAPI",
            dependencies: [
                "Starscream",
                "Promises"
            ]
        ),
        .testTarget(
            name: "KrakenAPITests",
            dependencies: ["KrakenAPI"]),
    ]
)
