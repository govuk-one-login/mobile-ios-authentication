import AppAuthCore
import UIKit

public class MockOIDAuthState_TokenInvalidRequest: OIDAuthState {
    public override class func authState(
        byPresenting authorizationRequest: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthStateAuthorizationCallback
    ) -> OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_TokenInvalidRequest()
        session.callback = callback
        return session
    }
}
