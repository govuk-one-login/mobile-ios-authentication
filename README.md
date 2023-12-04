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

3. Add `import Authentication` and `import UserDetails` in your source code.

## Package description

The Authentication package authenticates a users details and enables them to log into their account securely. This is done by providing them with a login session and token.

The package also integrates [openID](https://openid.net/developers/how-connect-works/) AppAuth and conforms to its standards, and also uses `NetworkClient` from the [Networking](https://github.com/govuk-one-login/mobile-ios-networking) package.

### Types

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

#### UserService

`UserService` implements the `UserServicing` protocol in order to make a request with an authentication token. The request will fetch the `UserInfo` object.

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
```

The struct also contains three enums to handle the language, the response and the scopes required for sending the `OIDAuthorizationRequest` within the AppAuthSession. 

#### AppAuthSession

A class to handle the login flow with the given auth provider and conforms to the `LoginSession` protocol. It uses the `UIWindow` to know where to display the login dialogue.

`present` takes configuration, which comes from `LoginSessionConfiguration`, as a parameter and contains the login information to make the request. 

`finalise` takes a URL to redirect to as a parameter and returns a token response. If `userAgent` was not assigned inside the `present` method an error is thrown. Otherwise, the token response is returned. 

## Example Implementation

### How to use the Authentication package

To use the Authentication package, first make sure your module or app has a dependency on Authentication and UserDetails and import both into the relevant file(s). Next, initialise an instance of LoginSession and LoginSessionConfiguration, then call `present` on your session, with the configuration as a parameter.

```swift
import Authentication
import UserDetails

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
                                              locale: .en)
                                              
session.present(configuration: configuration)

```

Your code should include a callback handler method in either the SceneDelegate or AppDelegate. Therefore, once `present` has been called and the user logs in, the web service will redirect to the app and the url passed back into the app is used to call `finalise`.

```swift
// SceneDelegate.swift

...

if let webURL = userActivity.webpageURL {
  viewController?.handleCallback(url: webURL)
}

```

**Note**: Depending on how your app has been configured, the callback handler should be placed within the corresponding delegate method in each file. For example, the impletentation for [SceneDelegate](https://developer.apple.com/documentation/uikit/uiscenedelegate/3238056-scene), [AppDelegate](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623072-application) and [SwiftUI](https://developer.apple.com/documentation/swiftui/environmentvalues/openurl) is as follows:

```swift
//SceneDelegate.swift

func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
  //handle callback
}

//AppDelegate.swift

func application(_ application: UIApplication, 
                continue userActivity: NSUserActivity,
                restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
                  // handle callback
                }

//SwiftUI

struct PlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onOpenURL { url in
          print(url)
        }
    }
  }
}

```

To get a token, call the finalise method on the session. The token can then be used to get an authenticatedClient, which in turn is used to create an instance of UserService.

`fetchUserInfo` can then be called on the UserService object to receive the required data.

```swift
do {
  let tokens = try await session.finalise(callback: url)
  let authenticatedClient = NetworkClient(authenticationProvider: tokens)
  let service = UserService(client: authenticatedClient)
  let userInfo = try await service.fetchUserInfo()
} catch {
  // handle errors
}
                
```
