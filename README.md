# di-mobile-ios-authentication

Implementation of Authentication package.

## Installation

To use Authentication in a SwiftPM project:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/govuk-one-login/mobile-ios-authentication", branch: "main"),
```

2. Add `Login` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
  .product(name: "Authentication", package: "di-mobile-ios-authentication")
]),
```

3. Add `import Authentication` in your source code.

## Package description

The Authentication package implements OpenID Connect to authenticates a user with an remote server.
Once authenticated, the package returns a set of tokens (refresh, access, id) that can be used for authorization to request remote resources (APIs).

### Types

#### LoginSessionConfiguration

Handles creating the `config` found in `LoginSession`. It requires the following to be initialised:

```swift
  let authorizationEndpoint: URL
  let tokenEndpoint: URL
  let responseType: ResponseType
  let scopes: [Scope]
   
  let clientID: String
   
  let prefersEphemeralWebSession: Bool
   
  let redirectURI: String
   
  let vectorsOfTrust: String
  let locale: UILocale
  let persistentSessionID: String?
```

The struct also contains three enums to handle the language, the response and the scopes required for sending the `OIDAuthorizationRequest` within the AppAuthSession. 

#### AppAuthSession

A class to handle the login flow with the given auth provider and conforms to the `LoginSession` protocol. It uses the `UIWindow` to know where to display the login modal.

`performLoginFlow` takes configuration, which comes from `LoginSessionConfiguration`, as a parameter and contains the login information to make the request. Any errors received in the authorization flow through the openID package are thrown. Otherwise, the token response is returned.

`finalise` takes a URL to redirect to as a parameter and returns a token response. If `userAgent` was not assigned inside the `present` method an error is thrown.

## Example Implementation

### How to use the Authentication package

To use the Authentication package, first, make sure your module or app has a dependency on Authentication and UserDetails and import both into the relevant file(s). Next, initialise an instance of AppAuthSession (which conforms to LoginSession) and LoginSessionConfiguration, then call `present` on your session, with the configuration as a parameter.

```swift
import Authentication
...

let session: LoginSession

  init(session: LoginSession) {
    self.session = session
  }

...

let configuration = LoginSessionConfiguration(authorizationEndpoint: url,
                                              responseType: .code,
                                              scopes: [.openid, .email, .phone, .offline_access],
                                              clientID: "someClientID",
                                              prefersEphemeralWebSession: true,
                                              redirectURI: "someRedirectURI",
                                              vectorsOfTrust: "someVectorOfTrust",
                                              locale: .en,
                                              persistentSessionId: nil)

session.performLoginFlow(configuration: configuration)

```

Your code should include a redirect URL handler method in either the SceneDelegate or AppDelegate. Therefore, once `performLoginFlow` has been called, the user logs in and selects a redirect link on the login modal. The device will redirect into the app and the url is passed into the call to `finalise`.

```swift
// SceneDelegate.swift

...

if let webURL = userActivity.webpageURL {
  viewController?.handleCallback(redirectURL: webURL)
}

```

**Note**: Depending on how your app has been configured, the redirect URL handler should be placed within the corresponding delegate method in each file. For example, the impletentation for [SceneDelegate](https://developer.apple.com/documentation/uikit/uiscenedelegate/3238056-scene), [AppDelegate](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623072-application) and [SwiftUI](https://developer.apple.com/documentation/swiftui/environmentvalues/openurl) is as follows:

```swift
//SceneDelegate.swift

func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
  //handle redirect URL
}

//AppDelegate.swift

func application(_ application: UIApplication, 
                continue userActivity: NSUserActivity,
                restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
                  // handle redirect URL
                }

//SwiftUI

struct PlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onOpenURL { url in
          // handle redirect URL
        }
    }
  }
}

```

To get a token, call the finalise method on the session.


```swift
do {
  let tokens = try await session.finalise(redirectURL: url)
  let authenticatedClient = NetworkClient(authenticationProvider: tokens)
} catch {
  // handle errors
}
                
```
