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
        externalUserAgent: any OIDExternalUserAgentSession
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = externalUserAgent
    }

    private static var stubRequests: [URL: any OIDExternalUserAgentSession] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        let externalUserAgent = Self.stubRequests[request.configuration.authorizationEndpoint] ?? MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()

        defer {
            NotificationCenter.default.post(name: MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted, object: externalUserAgent)
        }

        return externalUserAgent
    }
}
