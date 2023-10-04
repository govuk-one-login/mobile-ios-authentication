import AppAuth

public final class AppAuthSession: LoginSession {
    let window: UIWindow
    
    private var flow: OIDExternalUserAgentSession?
    private var authorizationCode: String?
    private var error: Error?
    private var state: String?
    private var stateReponse: String?
    
    private let service: TokenServicing
    
    public convenience init(window: UIWindow) {
        self.init(window: window,
                  service: TokenService(client: .init()))
    }
    
    init(window: UIWindow, service: TokenServicing) {
        self.window = window
        self.service = service
    }
    
    public func present(configuration: LoginSessionConfiguration) {
        guard let viewController = window.rootViewController else {
            return
        }
        
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
