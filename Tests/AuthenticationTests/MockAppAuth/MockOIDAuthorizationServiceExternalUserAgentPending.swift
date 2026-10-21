@preconcurrency import AppAuthCore
import UIKit

@MainActor
// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceExternalUserAgentPending: OIDAuthorizationService {
    static let authorizationFlowStarted = Notification.Name("MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted")

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentPending.Type {
        return MockOIDAuthorizationServiceExternalUserAgentPending.self
    }

    static func stub(
        authorizationRequest request: OIDAuthorizationRequest,
        externalUserAgentSession: any MockOIDExternalUserAgentSession
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = externalUserAgentSession
    }

    private static var stubRequests: [URL: any MockOIDExternalUserAgentSession] = [:]

    override public static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let externalUserAgentSession = Self.stubRequests[request.configuration.authorizationEndpoint] ?? MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow()

        externalUserAgentSession.callback = callback

        defer {
            NotificationCenter.default.post(name: MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted,
                                            object: externalUserAgentSession)
        }

        return externalUserAgentSession
    }
}
