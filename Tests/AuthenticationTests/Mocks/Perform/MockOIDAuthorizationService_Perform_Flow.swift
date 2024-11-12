import AppAuthCore
import UIKit

class MockOIDAuthorizationService_Perform_Flow: OIDAuthorizationService {
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
        let tokenResponse = MockTokenResponse_FullyFormed(
            request: OIDTokenRequest.mockTokenRequest,
            parameters: .init()
        )
        
        callback(tokenResponse, nil)
    }
}
