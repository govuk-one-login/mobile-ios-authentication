import AppAuthCore
import UIKit

// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse: OIDAuthorizationService {

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.self
    }

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        return MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()
    }
}
