// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TSKit.UI",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "TSKit.UI",
            targets: ["TSKit.UI", "TSKit.UI.Keyboard", "TSKit.UI.PageViewController"]),
        .library(
            name: "TSKit.UI.Keyboard",
            targets: ["TSKit.UI.Keyboard"]),
        .library(
            name: "TSKit.UI.PageViewController",
            targets: ["TSKit.UI.PageViewController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adya/TSKit.Core.git", .upToNextMajor(from: "2.3.0")),
        .package(url: "https://github.com/adya/TSKit.Log.git", .upToNextMajor(from: "2.3.0")),
    ],
    targets: [
        .target(
            name: "TSKit.UI",
            dependencies: ["TSKit.Core", "TSKit.Log"]),
        .target(
            name: "TSKit.UI.Keyboard",
            dependencies: []),
        .target(
            name: "TSKit.UI.PageViewController",
            dependencies: []),
        .testTarget(
            name: "TSKit.UITests",
            dependencies: ["TSKit.UI"]),
    ]
)
