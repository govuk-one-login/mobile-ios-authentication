import Foundation

public struct LoginErrorV2: Error, Equatable, LocalizedError {
    public let reason: LoginErrorReason
    public let underlyingReason: String?
    public var errorDescription: String? { underlyingReason }
    
    public init(
        reason: LoginErrorReason,
        underlyingReason: String? = nil
    ) {
        self.reason = reason
        self.underlyingReason = underlyingReason
    }
}

public enum LoginErrorReason: Equatable {
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
    case generic(description: String)
}
