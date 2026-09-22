import Foundation
import GDSUtilities

public typealias LoginError = LoginGDSError<LoginErrorKind>

public struct LoginGDSError<Kind: GDSErrorKind>: GDSError {
    public let kind: Kind
    public let reason: String?
    public let endpoint: String?
    public let statusCode: Int?
    public let file: String
    public let function: String
    public let line: Int
    public let resolvable: Bool
    public let originalError: (any Error)?
    public let additionalParameters: [String: any Sendable]

    public init(
        _ kind: Kind,
        reason: String? = nil,
        endpoint: String? = nil,
        statusCode: Int? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        resolvable: Bool = false,
        originalError: (any Error)? = nil,
        additionalParameters: [String: any Sendable] = [:]
    ) {
        self.kind = kind
        self.reason = reason
        self.endpoint = endpoint
        self.statusCode = statusCode
        self.file = file
        self.function = function
        self.line = line
        self.resolvable = resolvable
        self.originalError = originalError
        self.additionalParameters = additionalParameters
    }
}

public enum LoginErrorKind: Int, GDSErrorKind {
    // MARK: LoginErrorKind
    case generic = 1000
    case invalidRedirectURL = 1001

    // MARK: OIDGeneralErrorDomain
    case userCancelled = 2001 // OIDErrorCodeUserCanceledAuthorizationFlow
    case programCancelled = 2002 // OIDErrorCodeProgramCanceledAuthorizationFlow
    case network = 2003 // OIDErrorCodeNetworkError
    case generalServerError = 2004 // OIDErrorCodeServerError
    case safariOpenError = 2005 // OIDErrorCodeSafariOpenError
    
    // MARK: OIDOAuthAuthorizationErrorDomain
    case authorizationInvalidRequest = 3001 // OIDErrorCodeOAuthAuthorizationInvalidRequest
    case authorizationUnauthorizedClient = 3002 // OIDErrorCodeOAuthAuthorizationUnauthorizedClient
    case authorizationAccessDenied = 3003 // OIDErrorCodeOAuthAuthorizationAccessDenied
    case authorizationUnsupportedResponseType = 3004 // OIDErrorCodeOAuthAuthorizationUnsupportedResponseType
    case authorizationInvalidScope = 3005 // OIDErrorCodeOAuthAuthorizationAuthorizationInvalidScope
    case authorizationServerError = 3006 // OIDErrorCodeOAuthAuthorizationServerError
    case authorizationTemporarilyUnavailable = 3007 // OIDErrorCodeOAuthAuthorizationTemporarilyUnavailable
    case authorizationClientError = 3008 // OIDErrorCodeOAuthAuthorizationClientError
    case authorizationUnknownError = 3100 // OIDErrorCodeOAuthAuthorizationOther

    // MARK: OIDOAuthTokenErrorDomain
    case tokenInvalidRequest = 4001 // OIDErrorCodeOAuthInvalidRequest
    case tokenUnauthorizedClient = 4002 // OIDErrorCodeOAuthTokenUnauthorizedClient
    case tokenInvalidScope = 4003 // OIDErrorCodeOAuthTokenInvalidScope
    case tokenInvalidClient = 4004 // OIDErrorCodeOAuthTokenInvalidClient
    case tokenInvalidGrant = 4005 // OIDErrorCodeOAuthTokenInvalidGrant
    case tokenUnsupportedGrantType = 4006 // OIDErrorCodeOAuthTokenUnsupportedGrantType
    case tokenClientError = 4007 // OIDErrorCodeOAuthTokenClientError
    case tokenUnknownError = 4100 // OIDErrorCodeOAuthTokenOther
}
