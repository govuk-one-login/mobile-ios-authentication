import Networking

public struct TokenResponse: Codable {
    public let accessToken: String
    public let refreshToken: String?
    public let idToken: String
    public let tokenType: String
    public let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

extension TokenResponse: AuthenticationProvider {
    public var bearerToken: String {
        accessToken
    }
}
