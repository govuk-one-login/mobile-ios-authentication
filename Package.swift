// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"])
        
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git",
                 .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(name: "Authentication",
                dependencies: [
                    .product(name: "AppAuth", package: "AppAuth-iOS")
                ]),
        .testTarget(name: "AuthenticationTests",
                    dependencies: [
                        "Authentication"
                    ])
    ]
)
