import Foundation

public struct TokenResponse: Codable {
    public let accessToken: String
    public let refreshToken: String?
    public let idToken: String?
    public let tokenType: String
    public let expiryDate: Date
}
