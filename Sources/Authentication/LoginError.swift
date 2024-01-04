public enum LoginError: Error {
    case generic(description: String)
    case userCancelled
    case network
}
