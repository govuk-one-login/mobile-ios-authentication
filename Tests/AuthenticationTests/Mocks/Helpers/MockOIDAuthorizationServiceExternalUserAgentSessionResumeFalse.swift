import AppAuthCore
import UIKit

final class MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse: OIDAuthorizationService {

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.self
    }

    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        return MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()
    }
}
