@preconcurrency import AppAuthCore

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

    static func error(code: OIDErrorCodeOAuthToken, localizedDescription: String = "") -> Error {
        return NSError(domain: OIDOAuthTokenErrorDomain,
                       code: code.rawValue,
                       userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }

    static let invalidRequest: OIDError = OIDError(rawValue: "invalid_request")!
    static let unauthorizedClient: OIDError = OIDError(rawValue: "unauthorized_client")!
    static let accessDenied: OIDError = OIDError(rawValue: "access_denied")!
    static let invalidScope: OIDError = OIDError(rawValue: "invalid_scope")!
    static let invalidClient: OIDError = OIDError(rawValue: "invalid_client")!
    static let invalidGrant: OIDError = OIDError(rawValue: "invalid_grant")!
    static let unsupportedGrantType: OIDError = OIDError(rawValue: "unsupported_grant_type")!
    static let unknown: OIDError = OIDError(rawValue: "unknown")!

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
    static let invalidRequest = OIDError.error(code: OIDErrorCodeOAuth.invalidRequest)

    static let unauthorizedClient = OIDError.error(code: OIDErrorCodeOAuth.unauthorizedClient)

    static let accessDenied = OIDError.error(code: OIDErrorCodeOAuth.accessDenied)

    static let unsupportedResponseType = OIDError.error(code: OIDErrorCodeOAuth.unsupportedResponseType)

    static let invalidScope = OIDError.error(code: OIDErrorCodeOAuth.invalidScope)

    static let serverError = OIDError.error(code: OIDErrorCodeOAuth.serverError)

    static let temporarilyUnavailable = OIDError.error(code: OIDErrorCodeOAuth.temporarilyUnavailable)

    static let clientError = OIDError.error(code: OIDErrorCodeOAuth.clientError)

    static let other = OIDError.error(code: OIDErrorCodeOAuth.other)
}

struct OIDErrorOAuthToken {
    static let clientError = OIDError.error(code: OIDErrorCodeOAuthToken.clientError)
}
