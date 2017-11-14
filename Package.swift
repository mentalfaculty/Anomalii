// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Anomalii",
    products: [
        .library(
            name: "Anomalii",
            targets: ["Anomalii"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Anomalii",
            dependencies: []),
        .testTarget(
            name: "AnomaliiTests",
            dependencies: ["Anomalii"]),
    ]
)
