import AppAuthCore
import UIKit

public class MockOIDAuthState_AuthorizationInvalidRequest: OIDAuthState {
    public override class func authState(
        byPresenting authorizationRequest: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthStateAuthorizationCallback
    ) -> OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_AuthorizationInvalidRequest()
        session.callback = callback
        return session
    }
}
