// swift-tools-version: 5.9
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
                 .upToNextMajor(from: "1.0.0")
        ),
        .package(url: "https://github.com/govuk-one-login/mobile-ios-networking.git",
                 .upToNextMajor(from: "2.0.0")
        )
    ],
    targets: [
        .target(name: "Authentication",
                dependencies: [
                    .product(name: "AppAuth", package: "AppAuth-iOS"),
                    .product(name: "Networking", package: "mobile-ios-networking")
                ]),
        .testTarget(name: "AuthenticationTests",
                    dependencies: [
                        "Authentication"
                    ]),
        
        .target(name: "UserDetails",
                dependencies: [
                    .product(name: "Networking", package: "mobile-ios-networking")
                ]),
        .testTarget(name: "UserDetailsTests",
                    dependencies: [
                        "UserDetails",
                        .product(name: "MockNetworking", package: "mobile-ios-networking")
                    ])
    ]
)
