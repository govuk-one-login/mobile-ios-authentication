import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle redirects from auth service
@available(*, deprecated, renamed: "AppAuthSessionV2", message: "Errors thrown from this class have been enriched in AppAuthSessionV2")
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var userAgent: OIDExternalUserAgentSession?
    
    var isActive: Bool {
        userAgent != nil
    }
    
    private var loginTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        loginTask?.cancel()
    }
    
    /// Ensures `performLoginFlow` is public and can be called by the app
    /// Presents the login modal
    ///
    /// - Parameters:
    ///     - configuration: object that contains your LoginSessionConfiguration
    @MainActor
    public func performLoginFlow(
        configuration: LoginSessionConfiguration
    ) async throws -> TokenResponse {
        try await performLoginFlow(
            configuration: configuration,
            service: OIDAuthorizationService.self
        )
    }
    
    /// This is here for testing and allows `service` to be mocked
    @MainActor
    func performLoginFlow(
        configuration: LoginSessionConfiguration,
        service: OIDAuthorizationService.Type
    ) async throws -> TokenResponse {
        guard let viewController = window.rootViewController else {
            fatalError("empty vc in window, please add vc")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            userAgent = service.present(
                configuration.authorizationRequest,
                presenting: viewController,
                prefersEphemeralSession: configuration.prefersEphemeralWebSession
            ) { [unowned self] authResponse, error in
                loginTask = Task {
                    await finaliseLoginWithAuthResponse(
                        configuration: configuration,
                        service: service,
                        authorizationResponse: authResponse,
                        error: error,
                        continuation: continuation
                    )
                    userAgent = nil
                }
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
    
    private func finaliseLoginWithAuthResponse(
        configuration: LoginSessionConfiguration,
        service: OIDAuthorizationService.Type,
        authorizationResponse: OIDAuthorizationResponse?,
        error: Error?,
        continuation: CheckedContinuation<TokenResponse, any Error>
    ) async {
        do {
            let tokenRequest = try await handleAuthResponseCreateTokenRequest(
                authorizationResponse,
                error: error,
                tokenParameters: configuration.tokenParameters,
                tokenHeaders: configuration.tokenHeaders
            )
            service.perform(
                tokenRequest,
                originalAuthorizationResponse: authorizationResponse
            ) { [unowned self] tokenResponse, error in
                do {
                    let response = try handleTokenResponse(
                        tokenResponse,
                        error: error
                    )
                    continuation.resume(returning: response)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            continuation.resume(throwing: error)
        }
    }
    
    func handleAuthResponseCreateTokenRequest(
        _ authorizationResponse: OIDAuthorizationResponse?,
        error: Error?,
        tokenParameters: @escaping () async throws -> TokenParameters?,
        tokenHeaders: @escaping () async throws -> TokenHeaders?
    ) async throws -> OIDTokenRequest {
        try handleIfError(error)
        guard let authorizationResponse else {
            throw LoginError.generic(description: "No Authorization Response")
        }
        guard let tokenRequest = authorizationResponse.tokenExchangeRequest(
            withAdditionalParameters: try await tokenParameters(),
            additionalHeaders: try await tokenHeaders()
        ) else {
            throw LoginError.generic(description: "Couldn't create Token Request")
        }
        return tokenRequest
    }
    
    func handleTokenResponse(
        _ tokenResponse: OIDTokenResponse?,
        error: Error?
    ) throws -> TokenResponse {
        try handleIfError(error)
        guard let tokenResponse else {
            throw LoginError.generic(description: "No Token Response")
        }
        return try generateTokenResponse(token: tokenResponse)
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
        case (OIDOAuthAuthorizationErrorDomain, -7):
            throw LoginError.serverError
        case (OIDOAuthAuthorizationErrorDomain, -4):
            throw LoginError.accessDenied
        default:
            throw LoginError.generic(description: error.localizedDescription)
        }
    }
    
    private func generateTokenResponse(
        token: OIDTokenResponse
    ) throws -> TokenResponse {
        guard let accessToken = token.accessToken,
              let tokenType = token.tokenType,
              let expiryDate = token.accessTokenExpirationDate else {
            throw LoginError.generic(description: "Missing token property")
        }
        return TokenResponse(accessToken: accessToken,
                             refreshToken: token.refreshToken,
                             idToken: token.idToken,
                             tokenType: tokenType,
                             expiryDate: expiryDate)
    }
}
