// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
        .library(name: "UserDetails", targets: ["UserDetails"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git",
                 .upToNextMajor(from: "2.0.0")),
        .package(path: "https://github.com/alphagov/di-mobile-ios-networking")
    ],
    targets: [
        .target(name: "Authentication",
                dependencies: [
                    .product(name: "AppAuth", package: "AppAuth-iOS"),
                    "Networking"
                ]),
        .testTarget(name: "AuthenticationTests",
                    dependencies: [
                        "Authentication",
                        "Networking"
                    ]),
        
        .target(name: "UserDetails"),
    ]
)

