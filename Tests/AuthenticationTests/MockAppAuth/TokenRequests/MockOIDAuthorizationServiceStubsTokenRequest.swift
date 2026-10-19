@preconcurrency import AppAuthCore
import UIKit

@MainActor
class MockOIDAuthorizationServiceStubsTokenRequest: OIDAuthorizationService {

    static func mock() -> MockOIDAuthorizationServiceStubsTokenRequest.Type {
        return MockOIDAuthorizationServiceStubsTokenRequest.self
    }

    public static func stub(endPoint url: URL = URL(string: "https://token.build.account.gov.uk/token")!, error: Error) {
        Self.stubSessions[url] = error
    }

    private static var stubSessions: [URL: Error] = [:]

    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let session = MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow(authorizationResponse: .mock())
        DispatchQueue.main.async {
            callback(session.authorizationResponse, nil)
        }
        return session
    }

    public override class func perform(
        _ request: OIDTokenRequest,
        originalAuthorizationResponse authorizationResponse: OIDAuthorizationResponse?,
        callback: @escaping OIDTokenCallback
    ) {
        let error: Error = Self.stubSessions[request.configuration.tokenEndpoint] ?? OIDErrorOAuth.other

        DispatchQueue.main.async {
            callback(nil, error)
        }
    }
}
