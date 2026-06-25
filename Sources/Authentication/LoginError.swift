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
    // General Error Domain
    case generic = 1000
    case userCancelled = 1001
    case programCancelled = 1002
    case network = 1003
    case generalServerError = 1004
    case safariOpenError = 1005
    
    // Authorization Error Domain
    case authorizationInvalidRequest = 2001
    case authorizationUnauthorizedClient = 2002
    case authorizationAccessDenied = 2003
    case authorizationUnsupportedResponseType = 2004
    case authorizationInvalidScope = 2005
    case authorizationServerError = 2006
    case authorizationTemporarilyUnavailable = 2007
    case authorizationClientError = 2008
    case authorizationUnknownError = 2009

    // Redirect error domain
    case invalidRedirectURL = 3001

    // Token Error Domain
    case tokenUnknownError = 4000
    case tokenUnauthorizedClient = 4001
    case tokenUnsupportedGrantType = 4002
    case tokenClientError = 4003
    case tokenInvalidRequest = 4101
    case tokenInvalidScope = 4102
    case tokenInvalidClient = 4103
    case tokenInvalidGrant = 4104
    
    public var description: String {
        switch self {
        case .generic:
            return "generic"
        case .userCancelled:
            return "userCancelled"
        case .programCancelled:
            return "programCancelled"
        case .network:
            return "network"
        case .generalServerError:
            return "generalServerError"
        case .safariOpenError:
            return "safariOpenError"
        case .authorizationInvalidRequest:
            return "authorizationInvalidRequest"
        case .authorizationUnauthorizedClient:
            return "authorizationUnauthorizedClient"
        case .authorizationAccessDenied:
            return "authorizationAccessDenied"
        case .authorizationUnsupportedResponseType:
            return "authorizationUnsupportedResponseType"
        case .authorizationInvalidScope:
            return "authorizationInvalidScope"
        case .authorizationServerError:
            return "authorizationServerError"
        case .authorizationTemporarilyUnavailable:
            return "authorizationTemporarilyUnavailable"
        case .authorizationClientError:
            return "authorizationClientError"
        case .authorizationUnknownError:
            return "authorizationUnknownError"
        case .invalidRedirectURL:
            return "invalidRedirectURL"
        case .tokenUnknownError:
            return "tokenUnknownError"
        case .tokenUnauthorizedClient:
            return "tokenUnauthorizedClient"
        case .tokenUnsupportedGrantType:
            return "tokenUnsupportedGrantType"
        case .tokenClientError:
            return "tokenClientError"
        case .tokenInvalidRequest:
            return "tokenInvalidRequest"
        case .tokenInvalidScope:
            return "tokenInvalidScope"
        case .tokenInvalidClient:
            return "tokenInvalidClient"
        case .tokenInvalidGrant:
            return "tokenInvalidGrant"
        }
    }
}
