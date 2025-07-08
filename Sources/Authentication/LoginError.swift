import Foundation

@available(*, deprecated, renamed: "LoginErrorV2", message: "Errors as part of LoginErrorV2 are richer and include underlying error information")
public enum LoginError: Error, Equatable, LocalizedError {
    case clientError
    case generic(description: String)
    case invalidRequest
    case network
    case non200
    case userCancelled
    case serverError
    case accessDenied
    
    public var localizedDescription: String {
        switch self {
        case .clientError:
            return "client error"
        case .generic(description: let description):
            return description
        case .invalidRequest:
            return "invalid request"
        case .network:
            return "network"
        case .non200:
            return "non 200"
        case .userCancelled:
            return "user cancelled"
        case .serverError:
            return "server error"
        case .accessDenied:
            return "access denied"
        }
    }
    
    public var errorDescription: String? { return localizedDescription }
}
