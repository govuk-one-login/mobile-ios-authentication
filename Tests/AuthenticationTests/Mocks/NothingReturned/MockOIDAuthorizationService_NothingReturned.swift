import AppAuthCore
import UIKit

public class MockOIDAuthorizationService_NothingReturned: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_NothingReturned()
        session.callback = callback
        return session
    }
}
