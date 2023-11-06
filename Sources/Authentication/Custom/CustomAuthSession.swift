import AuthenticationServices
import UIKit

enum LoginError: Error {
    case inconsistentStateResponse
}

/// CustomAuthSession object handles login flow with given auth provider
public final class CustomAuthSession: NSObject, LoginSession {
    private let context: UIWindow
    private var session: ASWebAuthenticationSession?
    private(set) var state: String?
    private let nonce: String
    
    private let service: TokenServicing
    
    /// convenience init uses TokenService provided by package
    ///
    /// - Parameters:
    ///    - window: UIWindow with a root view controller where you wish to show the login dialog
    public convenience init(window: UIWindow) {
        self.init(window: window,
                  service: TokenService(client: .init()),
                  nonce: UUID().uuidString)
    }
    
    init(window: UIWindow, service: TokenServicing, nonce: String) {
        self.context = window
        self.service = service
        self.nonce = nonce
    }
    
    /// Shows the login dialog
    ///
    /// - Parameters:
    ///     - configuration: object that contains your LoginSessionConfiguration
    public func present(configuration: LoginSessionConfiguration) {
        var components = URLComponents(url: configuration.authorizationEndpoint,
                                       resolvingAgainstBaseURL: false)!
        
        self.state = UUID().uuidString
        components.queryItems = [
            .init(name: "response_type", value: configuration.responseType.rawValue),
            .init(name: "scope", value: configuration.scopes
                .map(\.rawValue).joined(separator: " ")),
            .init(name: "client_id", value: configuration.clientID),
            .init(name: "state", value: self.state),
            .init(name: "redirect_uri", value: configuration.redirectURI),
            .init(name: "vtr", value: configuration.vectorsOfTrust.description),
            .init(name: "nonce", value: nonce),
            .init(name: "ui_locales", value: configuration.locale.rawValue)
        ]
        
        session = ASWebAuthenticationSession(url: components.url!,
                                             callbackURLScheme: "https") { _, error in
            if let error = error {
                print("error on auth: \(error.localizedDescription), error object: \(error)")
                // throw error?
            }
        }
        session?.prefersEphemeralWebBrowserSession =
            configuration.prefersEphemeralWebSession
        session?.presentationContextProvider = self
        session?.start()
    }
    
    public func finalise(callback url: URL) async throws -> TokenResponse {
        await MainActor.run { session?.cancel() }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let authorizationCode = components.queryItems?
            .first(where: { $0.name == "code" })?
            .value,
              let state = components.queryItems?.first(where: { $0.name == "state"})?.value,
              state == self.state else {
            throw LoginError.inconsistentStateResponse
        }
        
        return try await service.fetchTokens(authorizationCode: authorizationCode)
    }
    
    public func cancel() {
        session?.cancel()
    }
}

extension CustomAuthSession: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        context
    }
}
