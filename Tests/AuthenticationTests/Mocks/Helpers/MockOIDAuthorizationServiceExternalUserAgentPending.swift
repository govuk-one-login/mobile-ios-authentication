import AppAuthCore
import UIKit

final class MockOIDAuthorizationServiceExternalUserAgentPending: OIDAuthorizationService {

    static let authorizationFlowStarted = Notification.Name("MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted")

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentPending.Type {
        return MockOIDAuthorizationServiceExternalUserAgentPending.self
    }

    static func stub(
        authorizationRequest request: OIDAuthorizationRequest,
        externalUserAgent: any MockOIDExternalUserAgentSession
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = externalUserAgent
    }

    private static var stubRequests: [URL: any MockOIDExternalUserAgentSession] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        let externalUserAgent = Self.stubRequests[request.configuration.authorizationEndpoint] ?? MockOIDExternalUserAgentSessionCancel(error: nil)

        externalUserAgent.callback = callback

        defer {
            NotificationCenter.default.post(name: MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted, object: externalUserAgent)
        }

        return externalUserAgent
    }
}
