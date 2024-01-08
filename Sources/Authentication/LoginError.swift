public enum LoginError: Error, Equatable {
    case clientError
    case generic(description: String)
    case invalidRequest
    case network
    case non200
    case userCancelled
}
