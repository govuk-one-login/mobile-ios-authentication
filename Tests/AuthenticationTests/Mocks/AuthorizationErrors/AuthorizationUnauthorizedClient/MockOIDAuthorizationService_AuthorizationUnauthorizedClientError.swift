import AppAuthCore
import UIKit

class MockOIDAuthorizationService_AuthorizationUnauthorizedClientError: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_AuthorizationUnauthorizedClientError()
        session.callback = callback
        return session
    }
}
