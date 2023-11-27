import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle callbacks from auth service
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var flow: OIDExternalUserAgentSession?
    private var authState: OIDAuthState?
    private var authError: Error?
    
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public init(window: UIWindow) {
        self.window = window
    }
    
    /// Shows the login dialog
    ///
    /// - Parameters:
    ///     - configuration: object that contains your loginSessionConfiguration
    @MainActor
    public func authenticate(configuration: LoginSessionConfiguration) {
        guard let viewController = window.rootViewController else {
            fatalError("empty vc in window, please add vc")
        }
        
        let config = OIDServiceConfiguration(
            authorizationEndpoint: configuration.authorizationEndpoint,
            tokenEndpoint: configuration.tokenEndpoint
        )
        
        let request = OIDAuthorizationRequest(
            configuration: config,
            clientId: configuration.clientID,
            scopes: configuration.scopes.map(\.rawValue),
            redirectURL: URL(string: configuration.redirectURI)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: [
                "vtr": configuration.vectorsOfTrust.description,
                "ui_locales": configuration.locale.rawValue
            ]
        )
        
        flow = OIDAuthState.authState(byPresenting: request,
                                      presenting: viewController) { authState, error in
            if let authState = authState {
                self.authState = authState
            }
            if let error = error {
                self.authError = error
            }
        }
    }
    
    public func evaluateAuthentication() throws -> TokenResponse {
        guard let authState = authState else {
            throw LoginError.generic(description: authError?.localizedDescription ?? "Unknown error")
        }
        
        guard let token = authState.lastTokenResponse,
              let accessToken = token.accessToken,
              let refreshToken = token.refreshToken,
              let idToken = token.idToken,
              let tokenType = token.tokenType else {
            throw LoginError.generic(description: "Missing authState property")
        }
        
        return TokenResponse(accessToken: accessToken,
                             refreshToken: refreshToken,
                             idToken: idToken,
                             tokenType: tokenType,
                             expiresIn: 180)
    }
    
    @MainActor
    public func finalise(redirectURL url: URL) {
        if let authorizationflow = flow,
           authorizationflow.resumeExternalUserAgentFlow(with: url) {
            flow = nil
        }
    }
    
    public func cancel() {
        flow?.cancel()
    }
}
