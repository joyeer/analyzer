// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analyzer",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "Common", type: .static, targets: ["Common"]),
        .library(name: "JavaAnalyzer", type: .static, targets: ["JavaAnalyzer"]),
        .library(name: "ApkAnalyzer", type: .static, targets: ["ApkAnalyzer"])
    ],
    targets: [
        .target(name: "Common"),
        .target(name: "JavaAnalyzer", dependencies: ["Common"]),
        .target(name: "ApkAnalyzer", dependencies: ["Common"]),
        .testTarget(name: "JavaTests", dependencies: ["JavaAnalyzer"], resources: [.copy("Resources/target/classes/")])
    ]
)
