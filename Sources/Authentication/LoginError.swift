public enum LoginError: Error {
    case clientError
    case invalidRequest
    case generic(description: String)
    case network
    case non200
    case userCancelled
}
