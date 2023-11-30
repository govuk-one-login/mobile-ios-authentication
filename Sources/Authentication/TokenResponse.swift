import Foundation
import Networking

public struct TokenResponse {
    public let accessToken: String
    public let refreshToken: String?
    public let idToken: String
    public let tokenType: String
    public let expiryDate: Date
}

extension TokenResponse: AuthenticationProvider {
    public var bearerToken: String {
        accessToken
    }
}
