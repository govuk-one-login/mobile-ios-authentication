import AppAuthCore
import UIKit

final class MockOIDAuthorizationServiceExternalUserAgentSessionResumePendingError: OIDAuthorizationService {

    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumePendingError.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumePendingError.self
    }

    ///
    /// - Parameters
    ///   - endPoint: the URL of the authorize end point for which you will be making a authorisation request at.
    ///   - sesssion: a user agent session to be returned by ``present(_:presenting:prefersEphemeralSession:callback)``. The user agent session will callback with an error.
    public static func stub(endPoint url: URL = URL(string: "https://token.account.gov.uk/authorize")!, session: MockOIDExternalUserAgentSessionResumeError) {
        Self.stubSessions[url] = (session)
    }

    private static var stubSessions: [URL: MockOIDExternalUserAgentSessionResumeError] = [:]

    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        guard let session = Self.stubSessions[request.configuration.authorizationEndpoint] else {
            return MockOIDExternalUserAgentSessionResumeError.error(code: .invalidAuthorizationFlow)
        }
        session.callback = callback
        return session
    }
}
