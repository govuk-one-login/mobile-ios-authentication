// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"])
        
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git",
                 .upToNextMajor(from: "2.0.0")
        ),
        .package(
            url: "https://github.com/govuk-one-login/mobile-ios-utilities",
            from: "0.1.1"
        )
    ],
    targets: [
        .target(name: "Authentication",
                dependencies: [
                    .product(name: "AppAuth", package: "AppAuth-iOS"),
                    .product(name: "GDSUtilities", package: "mobile-ios-utilities")
                ]),
        .testTarget(name: "AuthenticationTests",
                    dependencies: [
                        "Authentication"
                    ])
    ]
)
