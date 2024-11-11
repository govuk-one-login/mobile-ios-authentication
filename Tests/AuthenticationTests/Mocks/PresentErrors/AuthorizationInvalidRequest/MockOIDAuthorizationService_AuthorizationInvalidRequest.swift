import AppAuthCore
import UIKit

public class MockOIDAuthorizationService_AuthorizationInvalidRequest: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_AuthorizationInvalidRequest()
        session.callback = callback
        return session
    }
}
