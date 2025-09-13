// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bit2ConnectSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Bit2ConnectSDK",
            targets: ["Bit2ConnectSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Bit2ConnectSDK",
            dependencies: [
                "Alamofire",
                "SwiftyJSON"
            ],
            path: "Bit2ConnectSDK/Sources/Bit2ConnectSDK"
        ),
        .testTarget(
            name: "Bit2ConnectSDKTests",
            dependencies: ["Bit2ConnectSDK"],
            path: "Bit2ConnectSDK/Tests/Bit2ConnectSDKTests"
        ),
    ]
)
