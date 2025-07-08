import AppAuthCore
import UIKit

class MockOIDAuthorizationService_SafariOpenError: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_SafariOpenError()
        session.callback = callback
        return session
    }
}
