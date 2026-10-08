import AppAuthCore
import UIKit

// swiftlint:disable:next orphaned_doc_comment
///
/// Creates the real AppAuth authorization session using a stubbed external user agent.
///
// swiftlint:disable:next type_name
class MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting: OIDAuthorizationService {
    static func mock() -> MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting.Type {
        MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting.self
    }

    static func stub(
        authorizationRequest request: OIDAuthorizationRequest,
        externalUserAgent: any OIDExternalUserAgent
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = (request, externalUserAgent)
    }

    private static var stubRequests: [URL: (OIDAuthorizationRequest, any OIDExternalUserAgent)] = [:]

    override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        guard let (authorizationRequest, externalUserAgent) = Self.stubRequests[request.configuration.authorizationEndpoint] else {
            return MockOIDExternalUserAgentSessionResumeSuccess()
        }

        return OIDAuthorizationService.present(
            authorizationRequest,
            externalUserAgent: externalUserAgent,
            callback: callback
        )
    }
}

final class MockOIDExternalUserAgent: NSObject, OIDExternalUserAgent, Sendable {
    static let authorizationFlowStarted = Notification.Name("MockOIDExternalUserAgent.authorizationFlowStarted")

    func present(
        _ request: any OIDExternalUserAgentRequest,
        session: any OIDExternalUserAgentSession
    ) -> Bool {
        NotificationCenter.default.post(name: MockOIDExternalUserAgent.authorizationFlowStarted, object: self)
        return true
    }

    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        completion()
    }
}
