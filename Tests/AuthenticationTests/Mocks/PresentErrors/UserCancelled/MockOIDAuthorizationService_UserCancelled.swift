import AppAuthCore
import UIKit

final class MockOIDAuthorizationService_UserCancelled: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_UserCancelled()
        session.callback = callback
        return session
    }
}
