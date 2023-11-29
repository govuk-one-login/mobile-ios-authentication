import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle callbacks from auth service
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var userAgent: OIDExternalUserAgentSession?
    private var continuation: CheckedContinuation<TokenResponse, Error>?
    
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
    public func present(configuration: LoginSessionConfiguration, service: OIDAuthState.Type = OIDAuthState.self) {
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
            responseType: configuration.responseType.rawValue,
            additionalParameters: [
                "vtr": configuration.vectorsOfTrust.description,
                "ui_locales": configuration.locale.rawValue
            ]
        )
        
        userAgent = service.authState(byPresenting: request,
                                      presenting: viewController,
                                      prefersEphemeralSession: configuration.prefersEphemeralWebSession) { authState, error in
            self.handleResponse(authState: authState, error: error)
        }
    }
    
    private func handleResponse(authState: OIDAuthState?, error: Error?) {
        if let error {
            continuation?.resume(throwing: LoginError.generic(description: error.localizedDescription))
            userAgent = nil
            return
        }
        
        guard let authState = authState else {
            continuation?.resume(throwing: LoginError.generic(description: "No authState"))
            userAgent = nil
            return
        }
        
        guard let token = authState.lastTokenResponse else {
            continuation?.resume(throwing: LoginError.generic(description: "Missing authState Token Response"))
            return
        }
        
        guard let accessToken = token.accessToken,
              let idToken = token.idToken,
              let tokenType = token.tokenType,
              let expiryDate = token.accessTokenExpirationDate else {
            continuation?.resume(throwing: LoginError.generic(description: "Missing authState property"))
            userAgent = nil
            return
        }
        
        continuation?.resume(returning: TokenResponse(accessToken: accessToken,
                                                      refreshToken: authState.refreshToken,
                                                      idToken: idToken,
                                                      tokenType: tokenType,
                                                      expiresIn: Int(expiryDate.timeIntervalSince(Date()))))
    }
    
    @MainActor
    public func finalise(redirectURL url: URL) async throws -> TokenResponse {
        guard let userAgent else {
            throw LoginError.generic(description: "User Agent Session does not exist")
        }
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            userAgent.resumeExternalUserAgentFlow(with: url)
            self.userAgent = nil
        }
    }
}
