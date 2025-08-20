import AppAuthCore
import UIKit

class MockOIDAuthorizationService_ProgramCancelled: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_ProgramCancelled()
        session.callback = callback
        return session
    }
}
