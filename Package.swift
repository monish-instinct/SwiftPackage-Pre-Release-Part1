// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SwiftPackage",
    platforms: [
        .macOS(.v13)  // macOS 13 and above
    ],
    products: [
        .library(
            name: "SwiftPackage",
            targets: ["SwiftPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/stoneburner/SQLCipher", from: "0.0.4")
    ],
    targets: [
        .target(
            name: "SwiftPackage",
            dependencies: ["SQLCipher"]
        ),
        .testTarget(
            name: "SwiftPackageTests",
            dependencies: ["SwiftPackage"]
        ),
    ]
)
