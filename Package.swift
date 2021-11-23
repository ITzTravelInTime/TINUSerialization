// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TINUSerialization",
    platforms: [
        .macOS("10.9"),
        .iOS("8.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TINUSerialization",
            targets: ["TINUSerialization"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ITzTravelInTime/TINURecovery", from: "4.0.1"),
        .package(url: "https://github.com/ITzTravelInTime/SwiftLoggedPrint", from: "3.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TINUSerialization",
            dependencies: [
                .byName(name: "SwiftLoggedPrint"),
                .byName(name: "TINURecovery")
            ]),
        .testTarget(
            name: "TINUSerializationTests",
            dependencies: ["TINUSerialization"]),
    ]
)
