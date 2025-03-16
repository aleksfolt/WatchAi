// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "WatchAi",
    platforms: [
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "WatchAi",
            targets: ["WatchAi"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jdfergason/swift-toml", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "MyProject",
            dependencies: [
                .product(name: "TOML", package: "swift-toml")
            ]
        ),
        .testTarget(
            name: "MyProjectTests",
            dependencies: ["MyProject"]
        )
    ]
)
