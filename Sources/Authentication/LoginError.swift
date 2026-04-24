import Foundation
import GDSUtilities

@available(*, deprecated, renamed: "LoginError")
public typealias LoginErrorV2 = LoginError

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

public enum LoginErrorKind: String, GDSErrorKind {
    // General Error Domain
    case userCancelled
    case programCancelled
    case network
    case generalServerError
    case safariOpenError
    
    // Authorization Error Domain
    case authorizationInvalidRequest
    case authorizationUnauthorizedClient
    case authorizationAccessDenied
    case authorizationUnsupportedResponseType
    case authorizationInvalidScope
    case authorizationServerError
    case authorizationTemporarilyUnavailable
    case authorizationClientError
    case authorizationUnknownError

    // Redirect error domain
    case invalidRedirectURL

    // Token Error Domain
    case tokenInvalidRequest
    case tokenUnauthorizedClient
    case tokenInvalidScope
    case tokenInvalidClient
    case tokenInvalidGrant
    case tokenUnsupportedGrantType
    case tokenClientError
    case tokenUnknownError
    
    // Misc Error
    case generic
}
