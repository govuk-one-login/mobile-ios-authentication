import AppAuth
import AppAuthCore

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle redirects from auth service
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
                        error: error as? NSError,
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
        defer {
            // The server did not provide a valid OAuth redirect URL for error
            // Perform any manual clean-up
            window.rootViewController?.dismiss(animated: true)
            loginTask?.cancel()
        }
        guard let userAgent else {
            throw LoginError(reason: .generic(description: "User Agent Session does not exist"))
        }
        if !userAgent.resumeExternalUserAgentFlow(with: url) {
            if let params = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
               let errorType = params.first(where: { $0.name == "error" })?.value,
               let errorDescription = params.first(where: { $0.name == "error_description" })?.value {
                userAgent.failExternalUserAgentFlowWithError(
                    LoginError(
                        reason: .invalidRedirectURL,
                        underlyingReason: "\(errorType): \(errorDescription)"
                    )
                )
            } else {
                userAgent.failExternalUserAgentFlowWithError(LoginError(reason: .invalidRedirectURL))
            }
        }
    }
    
    private func finaliseLoginWithAuthResponse(
        configuration: LoginSessionConfiguration,
        service: OIDAuthorizationService.Type,
        authorizationResponse: OIDAuthorizationResponse?,
        error: NSError?,
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
                        error: error as? NSError
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
        error: NSError?,
        tokenParameters: @escaping () async throws -> TokenParameters?,
        tokenHeaders: @escaping () async throws -> TokenHeaders?
    ) async throws -> OIDTokenRequest {
        if let error {
            try handleError(error, origin: .authorize)
        }
        guard let authorizationResponse else {
            throw LoginError(reason: .generic(description: "No Authorization Response"))
        }
        guard let tokenRequest = authorizationResponse.tokenExchangeRequest(
            withAdditionalParameters: try await tokenParameters(),
            additionalHeaders: try await tokenHeaders()
        ) else {
            throw LoginError(reason: .generic(description: "Couldn't create Token Request"))
        }
        return tokenRequest
    }
    
    func handleTokenResponse(
        _ tokenResponse: OIDTokenResponse?,
        error: NSError?
    ) throws -> TokenResponse {
        if let error {
            try handleError(error, origin: .token)
        }
        guard let tokenResponse else {
            throw LoginError(reason: .generic(description: "No Token Response"))
        }
        return try generateTokenResponse(token: tokenResponse)
    }
    
    private func handleError(
        _ error: NSError,
        origin: ErrorOrigin
    ) throws {
        let errorDescription = error.userInfo[NSLocalizedDescriptionKey] as? String
        
        if let loginError = error as? LoginError,
           loginError.reason == .invalidRedirectURL {
            throw error
        }
        
        switch (error.domain, error.code) {
        // General Error Domain
        case (OIDGeneralErrorDomain, -3):
            throw LoginError(reason: .userCancelled, underlyingReason: errorDescription)
        case (OIDGeneralErrorDomain, -4):
            throw LoginError(reason: .programCancelled, underlyingReason: errorDescription)
        case (OIDGeneralErrorDomain, -5):
            throw LoginError(reason: .network, underlyingReason: errorDescription)
        case (OIDGeneralErrorDomain, -6):
            throw LoginError(reason: .generalServerError, underlyingReason: errorDescription)
        case (OIDGeneralErrorDomain, -9):
            throw LoginError(reason: .safariOpenError, underlyingReason: errorDescription)
        default:
            break
        }
        
        switch origin {
        case .authorize:
            try handleAuthorizationError(error, errorDescription)
        case .token:
            try handleTokenError(error, errorDescription)
        }
    }
    
    private func handleAuthorizationError(
        _ error: NSError,
        _ errorDescription: String?
    ) throws {
        switch (error.domain, error.code) {
        // Authorization Error Domain
        case (OIDOAuthAuthorizationErrorDomain, -2):
            throw LoginError(reason: .authorizationInvalidRequest, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -3):
            throw LoginError(reason: .authorizationUnauthorizedClient, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -4):
            throw LoginError(reason: .authorizationAccessDenied, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -5):
            throw LoginError(reason: .authorizationUnsupportedResponseType, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -6):
            throw LoginError(reason: .authorizationInvalidScope, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -7):
            throw LoginError(reason: .authorizationServerError, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -8):
            throw LoginError(reason: .authorizationTemporarilyUnavailable, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -61439):
            throw LoginError(reason: .authorizationClientError, underlyingReason: errorDescription)
        case (OIDOAuthAuthorizationErrorDomain, -61440):
            throw LoginError(reason: .authorizationUnknownError, underlyingReason: errorDescription)
        default:
            throw LoginError(reason: .generic(description: error.localizedDescription), underlyingReason: errorDescription)
        }
    }
    
    private func handleTokenError(
        _ error: NSError,
        _ errorDescription: String?
    ) throws {
        switch (error.domain, error.code) {
        // Token Error Domain
        case (OIDOAuthTokenErrorDomain, -2):
            throw LoginError(reason: .tokenInvalidRequest, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -3):
            throw LoginError(reason: .tokenUnauthorizedClient, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -6):
            throw LoginError(reason: .tokenInvalidScope, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -9):
            throw LoginError(reason: .tokenInvalidClient, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -10):
            throw LoginError(reason: .tokenInvalidGrant, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -11):
            throw LoginError(reason: .tokenUnsupportedGrantType, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -61439):
            throw LoginError(reason: .tokenClientError, underlyingReason: errorDescription)
        case (OIDOAuthTokenErrorDomain, -61440):
            throw LoginError(reason: .tokenUnknownError, underlyingReason: errorDescription)
        default:
            throw LoginError(reason: .generic(description: error.localizedDescription), underlyingReason: errorDescription)
        }
    }
    
    private func generateTokenResponse(
        token: OIDTokenResponse
    ) throws -> TokenResponse {
        guard let accessToken = token.accessToken,
              let tokenType = token.tokenType,
              let expiryDate = token.accessTokenExpirationDate else {
            throw LoginError(reason: .generic(description: "Missing token property"))
        }
        return TokenResponse(accessToken: accessToken,
                             refreshToken: token.refreshToken,
                             idToken: token.idToken,
                             tokenType: tokenType,
                             expiryDate: expiryDate)
    }
    
    private enum ErrorOrigin { case authorize, token }
}
