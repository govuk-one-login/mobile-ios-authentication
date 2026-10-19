@preconcurrency import AppAuthCore
import UIKit

// swiftlint:disable:next orphaned_doc_comment
///
/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` which simulates the case of
/// the authorisation flow never starting.
///
/// In this case, your code will receive a callback via ``OIDAuthorizationCallback`` with a ``OIDErrorCodeSafariOpenError`` before returning
/// a ``OIDExternalUserAgentSession`` session.
///
/// - SeeAlso: ``presentAuthorizationWithExternalUserAgent:callback:`` in ``OIDAuthorizationService`` for when this case occurs.
///
// swiftlint:disable:next type_name
@MainActor
final class MockOIDAuthorizationServiceNeverStartedAuthenticationSession: OIDAuthorizationService {

    /// Creates a new partial mock that can be used to perform authorisation requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:session:)`` to provide a stub session prior to performing an authorisation request.
    ///
    static func mock() -> MockOIDAuthorizationServiceNeverStartedAuthenticationSession.Type {
        return MockOIDAuthorizationServiceNeverStartedAuthenticationSession.self
    }

    private static var stubSessions: [URL: Error] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        callback(nil, OIDError.error(code: OIDErrorCode.safariOpenError, localizedDescription: "Unable to open Safari."))

        return MockOIDExternalUserAgentSessionResumeFailExternalUserAgentFlowWithError.mockResumeExternalUserAgentFlowWith()
    }
}
