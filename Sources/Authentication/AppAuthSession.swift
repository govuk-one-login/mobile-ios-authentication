import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle redirects from auth service
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var userAgent: OIDExternalUserAgentSession?
    private var continuation: CheckedContinuation<TokenResponse, Error>?
    
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public init(window: UIWindow) {
        self.window = window
    }
    
    /// Ensures `present` is public and can be called by the app
    /// Presents the login modal
    ///
    /// - Parameters:
    ///     - configuration: object that contains your LoginSessionConfiguration
    @MainActor
    public func present(configuration: LoginSessionConfiguration) throws {
        try present(configuration: configuration, service: OIDAuthState.self)
    }
    
    /// This is here for testing and allows `service` to be mocked
    @MainActor
    func present(configuration: LoginSessionConfiguration, service: OIDAuthState.Type = OIDAuthState.self) throws {
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
    
    /// Ensures `finalise` is public and can be called by the app
    /// Handles the redirect URL from the login modal
    ///
    /// - Parameter url: redirect URL from login modal
    /// - Returns: TokenResponse, tokens for the session
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
    
    private func handleResponse(authState: OIDAuthState?, error: Error?) {
        do {
            try checkNoError(error)
            let authState = try checkAuthState(authState)
            let token = try extractToken(authState: authState)
            let tokenResponse = try generateTokenResponse(token: token, authState: authState)
            continuation?.resume(returning: tokenResponse)
        } catch {
            continuation?.resume(throwing: error)
        }
    }
    
    private func checkNoError(_ error: Error?) throws {
        if let error {
            userAgent = nil
            throw LoginError.generic(description: error.localizedDescription)
        }
    }
    
    private func checkAuthState(_ authState: OIDAuthState?) throws -> OIDAuthState {
        guard let authState = authState else {
            userAgent = nil
            throw LoginError.generic(description: "No authState")
        }
        return authState
    }
    
    private func extractToken(authState: OIDAuthState) throws -> OIDTokenResponse {
        guard let token = authState.lastTokenResponse else {
            throw LoginError.generic(description: "Missing authState Token Response")
        }
        return token
    }
    
    private func generateTokenResponse(token: OIDTokenResponse, authState: OIDAuthState) throws -> TokenResponse {
        guard let accessToken = token.accessToken,
              let idToken = token.idToken,
              let tokenType = token.tokenType,
              let expiryDate = token.accessTokenExpirationDate else {
            userAgent = nil
            throw LoginError.generic(description: "Missing authState property")
        }
        return TokenResponse(accessToken: accessToken,
                             refreshToken: authState.refreshToken,
                             idToken: idToken,
                             tokenType: tokenType,
                             expiryDate: expiryDate)
    }
}
