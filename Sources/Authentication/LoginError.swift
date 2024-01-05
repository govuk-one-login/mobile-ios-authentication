public enum LoginError: Error {
    case clientError
    case generic(description: String)
    case invalidRequest
    case network
    case non200
    case userCancelled
}
