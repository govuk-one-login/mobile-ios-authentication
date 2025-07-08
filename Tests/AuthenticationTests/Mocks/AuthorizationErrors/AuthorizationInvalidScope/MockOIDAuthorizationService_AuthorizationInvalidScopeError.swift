import AppAuthCore
import UIKit

// swiftlint:disable:next type_name
class MockOIDAuthorizationService_AuthorizationInvalidScopeError: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_AuthorizationInvalidScopeError()
        session.callback = callback
        return session
    }
}
