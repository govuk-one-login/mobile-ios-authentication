import AppAuthCore
import UIKit

// swiftlint:disable:next type_name
class MockOIDAuthorizationService_TokenUnsupportedGrantTypeError: OIDAuthorizationService {
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSession_Success()
        session.callback = callback
        return session
    }
    
    public override class func perform(
        _ request: OIDTokenRequest,
        originalAuthorizationResponse authorizationResponse: OIDAuthorizationResponse?,
        callback: @escaping OIDTokenCallback
    ) {
        callback(
            nil,
            NSError(
                domain: OIDOAuthTokenErrorDomain,
                code: -11
            )
        )
    }
}
