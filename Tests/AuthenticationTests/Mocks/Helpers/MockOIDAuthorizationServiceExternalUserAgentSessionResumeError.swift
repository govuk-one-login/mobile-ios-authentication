import AppAuthCore
import UIKit

// swiftlint:disable:next orphaned_doc_comment
///
/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` which simulates how ``OIDAuthorizationService`` fails with an error
///
// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceExternalUserAgentSessionResumeError: OIDAuthorizationService {

    /// Creates a new partial mock that can be used to perform authorisation requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:session:)`` to provide a stub session prior to performing an authorisation request.
    ///
    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.self
    }

    ///
    /// - Parameters
    ///   - endPoint: the URL of the authorize end point for which you will be making a authorisation request at.
    ///   - sesssion: a user agent session to be returned by ``present(_:presenting:prefersEphemeralSession:callback)``. The user agent session will callback with an error.
    public static func stub(endPoint url: URL = URL(string: "https://token.account.gov.uk/authorize")!, error: Error) {
        Self.stubSessions[url] = error
    }

    private static var stubSessions: [URL: Error] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        let error: Error = Self.stubSessions[request.configuration.authorizationEndpoint] ?? OIDError.error(code: OIDErrorCode.safariOpenError)

        DispatchQueue.main.async {
            callback(nil, error)
        }

        return MockOIDExternalUserAgentSession.mock()
    }
}

final class MockOIDExternalUserAgentSessionResumeError: NSObject,
                                                        OIDExternalUserAgentSession {

    static func error(code: OIDErrorCode) -> MockOIDExternalUserAgentSessionResumeError {
        let error = NSError(domain: OIDGeneralErrorDomain,
                            code: code.rawValue)
        return MockOIDExternalUserAgentSessionResumeError(error: error)
    }

    var error: Error
    var callback: OIDAuthorizationCallback?

    init(error: Error) {
        self.error = error
    }

    public func cancel() { }

    public func cancel() async { }

    public func failExternalUserAgentFlowWithError(_ error: Error) { }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(
            nil,
            error,
        )
        return true
    }
}
