import AppAuthCore
import UIKit

public class MockOIDAuthorizationService_MissingAuthStateProperty: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_MissingAuthStateProperty()
        session.callback = callback
        return session
    }
    
    public override class func perform(
        _ request: OIDTokenRequest,
        originalAuthorizationResponse authorizationResponse: OIDAuthorizationResponse?,
        callback: @escaping OIDTokenCallback
    ) {
        let error: Error? = NSError(domain: OIDGeneralErrorDomain, code: -6)
        callback(nil, error)
    }
}
