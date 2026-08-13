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
    case userCancelled = 2001 // -3
    case programCancelled = 2002 // -4
    case network = 2003 // -5
    case generalServerError = 2004 // -6
    case safariOpenError = 2005 // -9
    
    // MARK: OIDOAuthAuthorizationErrorDomain
    case authorizationInvalidRequest = 3001 // -2
    case authorizationUnauthorizedClient = 3002 // -3
    case authorizationAccessDenied = 3003 // -4
    case authorizationUnsupportedResponseType = 3004 // -5
    case authorizationInvalidScope = 3005 // -6
    case authorizationServerError = 3006 // -7
    case authorizationTemporarilyUnavailable = 3007 // -8
    case authorizationClientError = 3008 // -0xEFFF (aka -61439)
    case authorizationUnknownError = 3100 // -0xF000 (aka -61440)

    // MARK: OIDOAuthTokenErrorDomain
    case tokenInvalidRequest = 4001 // -2
    case tokenUnauthorizedClient = 4002 // -3
    case tokenInvalidScope = 4003 // -6
    case tokenInvalidClient = 4004 // -9
    case tokenInvalidGrant = 4005 // -10
    case tokenUnsupportedGrantType = 4006 // -11
    case tokenClientError = 4007 // -0xEFFF (aka -61439)
    case tokenUnknownError = 4100 // -0xF000 (aka -61440)
}
