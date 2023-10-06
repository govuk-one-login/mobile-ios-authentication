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
    .product(name: "Login", package: "di-mobile-ios-login")
]),
```

3. Add `import Authentication` in your source code.

## Package description

The Login package authenticates a users details and enables them to log into their account securely. This is done by providing them with a login session and token.

The package also integrates openID AppAuth and conforms to its standards, and also uses `NetworkClient` from the [Networking](https://github.com/alphagov/di-mobile-ios-networking)


### Protocols


### Types


#### UserService

`UserService` implements the `UserServicing` protocol. `fetchUserInfo` makes a request with an authentication token. The request will fetch the `UserInfo` object.

#### UserInfo

A struct which conforms to `Codable`. It requires the following to be implemented:

```swift
public struct UserInfo: Codable {
  let sub: String
  let phoneNumberVerified: Bool
  let phoneNumber: String?
  let emailVerified: Bool
  public let email: String
}
```

#### LoginSessionConfiguration

Handles creating the `config` found in `LoginSession`. It requires the following to be initialised:

```swift
  let authorizationEndpoint: URL
  let responseType: ResponseType
  let scopes: [Scope]
   
  let clientID: String
   
  let prefersEphemeralWebSession: Bool
  let state: String = UUID().uuidString
   
  let redirectURI: String
   
  let nonce: String
  let viewThroughRate: String
  let locale: UILocale
```

The struct also contains 3 enums to handle the language, the response and scopes required for sending the `OIDAuthorizationRequest`. 

#### AppAuthSession

A class to handle the login flow with the given auth provider and conforms to the `LoginSession` protocol. It uses the `UIWindow` to know where to display the login dialogue.

`present` takes configuration as a parameter, which comes from `LoginSessionConfiguration` and contains the login information to make the request. 

`finalise` takes a URL as a callback and returns a token response. However, if no authorization code is found, an error will be thrown.

#### Extensions

## Error Handling

## Example Implementation

### How to use the Login Client

To use the Login package, first make sure your module or app has a dependency on Authentication and UserDetails and import both into the relevant file(s).

```swift
import Authentication
import UserDetails

...

let session: LoginSession
    
    init(session: LoginSession) {
        self.session = session
    }

...

```

