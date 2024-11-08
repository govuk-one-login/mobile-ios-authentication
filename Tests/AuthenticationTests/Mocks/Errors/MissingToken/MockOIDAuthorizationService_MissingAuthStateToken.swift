import AppAuthCore
import UIKit

public class MockOIDAuthorizationService_MissingAuthStateToken: OIDAuthorizationService {
    override public class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_MissingAuthStateToken()
        session.callback = callback
        return session
    }
    
    override public class func perform(
        _ request: OIDTokenRequest,
        originalAuthorizationResponse authorizationResponse: OIDAuthorizationResponse?,
        callback: @escaping OIDTokenCallback
    ) {
        callback(nil, nil)
    }
}
