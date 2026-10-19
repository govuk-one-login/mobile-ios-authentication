@preconcurrency import AppAuthCore

protocol MockOIDExternalUserAgentSession: OIDExternalUserAgentSession {
    var authorizationResponse: OIDAuthorizationResponse? { get }
    var error: Error? { get }
    var callback: OIDAuthorizationCallback? { get set }
}
