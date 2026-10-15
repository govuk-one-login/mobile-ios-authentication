import AppAuthCore
import UIKit

// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse: OIDAuthorizationService {

    static let authorizationFlowStarted = Notification.Name("MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted")

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.self
    }

    static func stub(
        authorizationRequest request: OIDAuthorizationRequest,
        externalUserAgentSession: any MockOIDExternalUserAgentSession
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = externalUserAgentSession
    }

    private static var stubRequests: [URL: any MockOIDExternalUserAgentSession] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        let externalUserAgentSession = Self.stubRequests[request.configuration.authorizationEndpoint] ?? MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()

        externalUserAgentSession.callback = callback

        defer {
            NotificationCenter.default.post(name: MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted, object: externalUserAgentSession)
        }

        return externalUserAgentSession
    }
}
