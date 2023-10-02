import AuthenticationServices
import UIKit

enum LoginError: Error {
    case inconsistentStateResponse
}

public final class CustomAuthSession: NSObject, LoginSession {
    private let context: UIWindow
    private var session: ASWebAuthenticationSession?
    private var state: String?
    
    private let service: TokenServicing
    
    public convenience init(window: UIWindow) {
        self.init(window: window,
                  service: TokenService(client: .init()))
    }
    
    init(window: UIWindow, service: TokenServicing) {
        self.context = window
        self.service = service
    }
    
    public func present(configuration: LoginSessionConfiguration) {
        var components = URLComponents(url: configuration.authorizationEndpoint,
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = [
            .init(name: "response_type", value: configuration.responseType.rawValue),
            .init(name: "scope", value: configuration.scopes
                .map(\.rawValue).joined(separator: " ")),
            .init(name: "client_id", value: configuration.clientID),
            .init(name: "state", value: configuration.state),
            .init(name: "redirect_uri", value: configuration.redirectURI),
            .init(name: "vtr", value: configuration.viewThroughRate),
            .init(name: "nonce", value: configuration.nonce),
            .init(name: "ui_locales", value: configuration.locale.rawValue)
        ]
        
        self.state = configuration.state
        
        session = ASWebAuthenticationSession(url: components.url!,
                                             callbackURLScheme: "https") { _, error in
            if let error = error {
                print("error on auth: \(error.localizedDescription), error object: \(error)")
                // todo throw error
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