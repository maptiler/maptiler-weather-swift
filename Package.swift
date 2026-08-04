// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MapTilerWeather",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MapTilerWeather",
            targets: ["MapTilerWeather"])
    ],
    dependencies: [
        // Production URL for MapTiler SDK
        .package(url: "https://github.com/maptiler/maptiler-sdk-swift.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MapTilerWeather",
            dependencies: [
                .product(name: "MapTilerSDK", package: "MapTilerSDK")
            ]
        ),
        .testTarget(
            name: "MapTilerWeatherTests",
            dependencies: ["MapTilerWeather"]
        )
    ]
)
