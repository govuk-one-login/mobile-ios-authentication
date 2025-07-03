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
    case clientError
    case generic(description: String)
    case invalidRequest
    case network
    case non200
    case userCancelled
    case serverError
    case accessDenied
}
