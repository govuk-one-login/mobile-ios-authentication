import AppAuth

/// AppAuthSession object handle login flow with given auth provider
/// Uses AppAuth Libary for presentation logic of login flow and handle callbacks from auth service
public final class AppAuthSession: LoginSession {
    let window: UIWindow
    
    private var flow: OIDExternalUserAgentSession?
    private(set) var authorizationCode: String?
    private(set) var error: Error?
    private var state: String?
    private(set) var stateReponse: String?
    
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
    public func present(configuration: LoginSessionConfiguration) {
        guard let viewController = window.rootViewController else {
            assertionFailure("empty vc in window, please add vc")
            return
        }
        
        // state is stored for later use to compare against state in reponse object
        self.state = configuration.state
        
        let config = OIDServiceConfiguration(
            authorizationEndpoint: configuration.authorizationEndpoint,
            tokenEndpoint: URL(string: "https://oidc.integration.account.gov.uk/token")!)
        
        let request = OIDAuthorizationRequest(
            configuration: config,
            clientId: configuration.clientID,
            scopes: configuration.scopes.map(\.rawValue),
            redirectURL: URL(string: configuration.redirectURI)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: [
                "vtr": configuration.viewThroughRate,
                "nonce": configuration.nonce,
                "ui_locales": configuration.locale.rawValue
            ]
        )
        
        let agent = OIDExternalUserAgentIOS(
            presenting: viewController,
            prefersEphemeralSession: configuration.prefersEphemeralWebSession
        )
        
        flow = OIDAuthorizationService.present(request,
                                                   externalUserAgent: agent!) { [unowned self] response, error in
            self.authorizationCode = response?.authorizationCode
            self.stateReponse = response?.state
            self.error = error
        }
    }
    
    
    @MainActor
    public func finalise(callback url: URL) async throws -> TokenResponse {
        flow?.resumeExternalUserAgentFlow(with: url)
        
        guard let authorizationCode,
              self.state == stateReponse else {
            throw error ?? LoginError.inconsistentStateResponse
        }
        return try await service
            .fetchTokens(authorizationCode: authorizationCode)
    }
    
    public func cancel() {
        flow?.cancel()
    }
}
