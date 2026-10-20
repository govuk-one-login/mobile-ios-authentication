@preconcurrency import AppAuthCore
import UIKit

///
/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` which simulates how ``OIDAuthorizationService`` fails with an error
///
@MainActor
// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceAuthorizationRequestError: OIDAuthorizationService {

    /// Creates a new mock that can be used to perform authorisation requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:error:)`` to provide a stub error prior to performing an authorisation request.
    ///
    static func mock() -> MockOIDAuthorizationServiceAuthorizationRequestError.Type {
        return MockOIDAuthorizationServiceAuthorizationRequestError.self
    }

    ///
    /// - Parameters
    ///   - endPoint: the URL of the authorize end point for which you will be making a authorisation request at.
    ///   - error: the error that this `OIDAuthorizationService` service will get a callback with
    public static func stub(endPoint url: URL = URL(string: "https://token.build.account.gov.uk/authorize")!, error: Error) {
        Self.stubSessions[url] = error
    }

    private static var stubSessions: [URL: Error] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let error: Error = Self.stubSessions[request.configuration.authorizationEndpoint] ?? OIDError.error(code: OIDErrorCodeOAuth.other)

        DispatchQueue.main.async {
            callback(nil, error)
        }

        return MockOIDExternalUserAgentSessionResumeFailExternalUserAgentFlowWithError.mockResumeExternalUserAgentFlowWith()
    }
}
