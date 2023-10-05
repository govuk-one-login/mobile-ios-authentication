# di-mobile-ios-login

Implementation of Login client.

## Installation

To use Login in a SwiftPM project:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/alphagov/di-mobile-ios-login", branch: "main"),
```

2. Add `Login` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
    .product(name: "Login", package: "dcmaw-login")
]),
```

3. Add `import Login` in your source code.

## Package description

The Login package authenticates a users details and enables them to log into their account securely. This is done by providing them with a login session and token and rejects attempts if an authorization code is not received.

The package also integrates openID AppAuth and conforms to its standards.

