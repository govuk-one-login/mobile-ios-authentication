import AppAuthCore
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
final class MockOIDAuthorizationServiceNeverStartedAuthenticationSession: OIDAuthorizationService {

    /// Creates a new partial mock that can be used to perform authorisation requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:session:)`` to provide a stub session prior to performing an authorisation request.
    ///
    static func mock() -> MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.Type {
        return MockOIDAuthorizationServiceExternalUserAgentSessionResumeError.self
    }

    private static var stubSessions: [URL: Error] = [:]

    public override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {

        callback(nil, OIDError.error(code: OIDErrorCode.safariOpenError, localizedDescription: "Unable to open Safari."))

        return MockOIDExternalUserAgentSessionResumeFalseWithoutCallback.mock()
    }
}

struct OIDError: RawRepresentable, Codable {

    typealias RawValue = String

    // MARK: OIDGeneralErrorDomain
    static let issuerMismatch = OIDError.error(code: OIDErrorCode.idTokenFailedValidationError, localizedDescription: "Issuer mismatch")

    static let audienceMismatch = OIDError.error(code: OIDErrorCode.idTokenFailedValidationError, localizedDescription: "Audience mismatch")

    static let idTokenExpired = OIDError.error(code: OIDErrorCode.idTokenFailedValidationError, localizedDescription: "ID Token expired")

    static func serverError(url: URL, statusCode: Int) -> Error {
        OIDError.error(code: OIDErrorCode.serverError, localizedDescription: "Non-200 HTTP response (\(statusCode) making token request to '\(url)'.")
    }
    static func networkError(url: URL, error: URLError = URLError(.networkConnectionLost)) -> Error {
        OIDError.error(code: OIDErrorCode.networkError, localizedDescription: "Connection error making token request to \(url): \(error.localizedDescription).")
    }

    static let userCanceledAuthorizationFlow = OIDError.error(code: OIDErrorCode.userCanceledAuthorizationFlow)

    static func error(code: OIDErrorCode, localizedDescription: String = "") -> Error {
        return NSError(domain: OIDGeneralErrorDomain,
                       code: code.rawValue,
                       userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }

    static func error(code: OIDErrorCodeOAuth, localizedDescription: String = "") -> Error {
        return NSError(domain: OIDOAuthAuthorizationErrorDomain,
                       code: code.rawValue,
                       userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }

    static let accessDenied: OIDError = OIDError(rawValue: "access_denied")!
    static let invalidRequest: OIDError = OIDError(rawValue: "invalid_request")!

    enum CodingKeys: String, CodingKey {
        case error
    }

    let rawValue: String

    init?(rawValue: String) {
        self.rawValue = rawValue
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .error)
    }
}

struct OIDErrorOAuth {
    // MARK: OIDOAuthAuthorizationErrorDomain
    static let accessDenied = OIDError.error(code: OIDErrorCodeOAuth.accessDenied)

    static let invalidRequest = OIDError.error(code: OIDErrorCodeOAuth.invalidRequest)
}
