import AppAuthCore
import UIKit

final class MockOIDAuthorizationService_Perform_ClientError: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_Perform_ClientError()
        session.callback = callback
        return session
    }
    
    public override class func perform(
        _ request: OIDTokenRequest,
        originalAuthorizationResponse authorizationResponse: OIDAuthorizationResponse?,
        callback: @escaping OIDTokenCallback
    ) {
        let error: Error? = NSError(
            domain: OIDOAuthAuthorizationErrorDomain,
            code: -61439
        )
        callback(nil, error)
    }
}
