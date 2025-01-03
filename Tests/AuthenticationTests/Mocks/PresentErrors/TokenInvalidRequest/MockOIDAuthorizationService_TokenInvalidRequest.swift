import AppAuthCore
import UIKit

class MockOIDAuthorizationService_TokenInvalidRequest: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_TokenInvalidRequest()
        session.callback = callback
        return session
    }
}
