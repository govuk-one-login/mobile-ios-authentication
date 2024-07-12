import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle redirects from auth service
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var userAgent: OIDExternalUserAgentSession?
    var isActive: Bool {
        userAgent != nil
    }
    
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public init(window: UIWindow) {
        self.window = window
    }
    
    /// Ensures `performLoginFlow` is public and can be called by the app
    /// Presents the login modal
    ///
    /// - Parameters:
    ///     - configuration: object that contains your LoginSessionConfiguration
    @MainActor
    public func performLoginFlow(configuration: LoginSessionConfiguration) async throws -> TokenResponse {
        try await performLoginFlow(configuration: configuration, service: OIDAuthState.self)
    }
    
    /// This is here for testing and allows `service` to be mocked
    @MainActor
    func performLoginFlow(configuration: LoginSessionConfiguration, service: OIDAuthState.Type) async throws -> TokenResponse {
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
            additionalParameters: {
                var params = [
                    "vtr": configuration.vectorsOfTrust.description,
                    "ui_locales": configuration.locale.rawValue
                ]
                if let persistentSessionId = configuration.persistentSessionId {
                    params["govuk_signin_session_id"] = persistentSessionId
                }
                return params
            }()
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            userAgent = service.authState(byPresenting: request,
                                          presenting: viewController,
                                          prefersEphemeralSession: configuration.prefersEphemeralWebSession) { authState, error in
                do {
                    let response = try self.handleResponse(authState: authState, error: error)
                    continuation.resume(returning: response)
                } catch {
                    continuation.resume(throwing: error)
                }
                self.userAgent = nil
            }
        }
    }
    
    /// Ensures `finalise` is public and can be called by the app
    /// Handles the redirect URL from the login modal
    ///
    /// - Parameter url: redirect URL from login modal
    /// - Returns: TokenResponse, tokens for the session
    @MainActor
    public func finalise(redirectURL url: URL) throws {
        guard let userAgent else {
            self.userAgent = nil
            throw LoginError.generic(description: "User Agent Session does not exist")
        }
        userAgent.resumeExternalUserAgentFlow(with: url)
    }
    
    private func handleResponse(authState: OIDAuthState?, error: Error?) throws -> TokenResponse {
        try handleIfError(error)
        let authState = try checkAuthState(authState)
        let token = try extractToken(authState: authState)
        let tokenResponse = try generateTokenResponse(token: token, authState: authState)
        return tokenResponse
    }
    
    private func handleIfError(_ error: Error?) throws {
        guard let error = error as? NSError else {
            return
        }
        
        switch (error.domain, error.code) {
        case (OIDGeneralErrorDomain, -3):
            throw LoginError.userCancelled
        case (OIDGeneralErrorDomain, -5):
            throw LoginError.network
        case (OIDGeneralErrorDomain, -6):
            throw LoginError.non200
        case (OIDOAuthAuthorizationErrorDomain, -2), (OIDOAuthTokenErrorDomain, -2):
            throw LoginError.invalidRequest
        case (OIDOAuthAuthorizationErrorDomain, -61439):
            throw LoginError.clientError
        default:
            throw LoginError.generic(description: error.localizedDescription)
        }
    }
    
    private func checkAuthState(_ authState: OIDAuthState?) throws -> OIDAuthState {
        guard let authState else {
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
              let tokenType = token.tokenType,
              let expiryDate = token.accessTokenExpirationDate else {
            throw LoginError.generic(description: "Missing authState property")
        }
        return TokenResponse(accessToken: accessToken,
                             refreshToken: authState.refreshToken,
                             idToken: token.idToken,
                             tokenType: tokenType,
                             expiryDate: expiryDate)
    }
}
