// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
        .library(name: "UserDetails", targets: ["UserDetails"])
        
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git",
                 branch: "master"),
        .package(url: "https://github.com/alphagov/di-mobile-ios-networking",
                branch: "main")
    ],
    targets: [
        .target(name: "Authentication",
                dependencies: [
                    .product(name: "AppAuth", package: "AppAuth-iOS"),
                    .product(name: "Networking", package: "di-mobile-ios-networking")
                ]),
        .testTarget(name: "AuthenticationTests",
                    dependencies: [
                        "Authentication",
                        "UserDetails",
                        .product(name: "MockNetworking", package: "di-mobile-ios-networking")
                    ]),
        
        .target(name: "UserDetails",
               dependencies: [
                .product(name: "Networking", package: "di-mobile-ios-networking")
               ])
    ]
)
