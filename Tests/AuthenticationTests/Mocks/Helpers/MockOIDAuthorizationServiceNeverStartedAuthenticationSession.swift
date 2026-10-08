import AppAuthCore
import UIKit

/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` which simulates the case of
/// the authorisation flow never starting.
///
/// In this case, your code will receive a callback via ``OIDAuthorizationCallback`` with a ``OIDErrorCodeSafariOpenError`` before returning a ``OIDExternalUserAgentSession`` session.
///
/// - SeeAlso: ``presentAuthorizationWithExternalUserAgent:callback:`` in ``OIDAuthorizationService`` for when this case occurs.
final class MockOIDAuthorizationServiceNeverStartedAuthenticationSession: OIDAuthorizationService {

    /// Creates a new partial mock that can be used to perform authorisation requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:session:)`` to provide a stub session prior to performing an authorisation request.
    ///
    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.self
    }

    private static var stubSessions: [URL: Error] = [:]

    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        callback(nil, OIDError.error(code: OIDErrorCode.safariOpenError))

        return MockOIDExternalUserAgentSession.mock()
    }
}

final class MockOIDExternalUserAgentSession: NSObject,
                                             OIDExternalUserAgentSession {

    static func mock() -> MockOIDExternalUserAgentSession {
        return MockOIDExternalUserAgentSession()
    }

    public func cancel() { }

    public func cancel() async { }

    public func failExternalUserAgentFlowWithError(_ error: Error) { }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        return false
    }
}

struct OIDError {
    static func error(code: OIDErrorCode) -> Error {
        return NSError(domain: OIDGeneralErrorDomain,
                       code: code.rawValue)
    }
}
