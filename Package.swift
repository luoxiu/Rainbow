// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Rainbow",
    products: [
        .library(name: "Rainbow", targets: ["Rainbow"]),
    ],
    targets: [
        .target(name: "Rainbow", dependencies: []),
        .testTarget(name: "RainbowTests", dependencies: ["Rainbow"]),
    ]
)
