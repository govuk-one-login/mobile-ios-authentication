import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle callbacks from auth service
public final class AppAuthSession: LoginSession {
    private let window: UIWindow
    private var flow: OIDExternalUserAgentSession?
    private(set) var authorizationCode: String?
    private var error: Error?
    private(set) var state: String?
    private(set) var stateReponse: String?
    var tokenResponse: TokenResponse?
    
    private let service: TokenServicing
    
    /// convenience init uses TokenService provided by package
    ///
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public convenience init(window: UIWindow) {
        self.init(window: window,
                  service: TokenService(client: .init()))
    }
    
    init(window: UIWindow, service: TokenServicing) {
        self.window = window
        self.service = service
    }
    
    /// Shows the login dialog
    ///
    /// - Parameters:
    ///     - configuration: object that contains your loginSessionConfiguration
    @MainActor
    public func present(configuration: LoginSessionConfiguration) {
        guard let viewController = window.rootViewController else {
            assertionFailure("empty vc in window, please add vc")
            return
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
            if let error = error {
                print(error)
            }
            if let authState = authState {
                print(authState)
                guard let token = authState.lastTokenResponse,
                      let accessToken = token.accessToken,
                      let refreshToken = token.refreshToken,
                      let idToken = token.idToken,
                      let tokenType = token.tokenType else { return }
                self.tokenResponse = TokenResponse(accessToken: accessToken, refreshToken: refreshToken, idToken: idToken, tokenType: tokenType, expiresIn: 180)
            }
        }
    }
    
    
    @MainActor
    public func finalise(redirectURL url: URL) {
        if let authorizationflow = flow,
           authorizationflow.resumeExternalUserAgentFlow(with: url) {
            flow = nil
        }
    }
    
    public func finalise(callback: URL) async throws -> TokenResponse {
        return TokenResponse(accessToken: "", refreshToken: "", idToken: "", tokenType: "", expiresIn: 1)
    }
    
    public func cancel() {
        flow?.cancel()
    }
}
