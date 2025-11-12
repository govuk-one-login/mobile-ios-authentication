import Foundation

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String?
    public let idToken: String?
    public let tokenType: String
    public let expiryDate: Date
    
    public init(
        accessToken: String,
        refreshToken: String? = nil,
        idToken: String? = nil,
        tokenType: String,
        expiryDate: Date
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.tokenType = tokenType
        self.expiryDate = expiryDate
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try values.decode(
            String.self,
            forKey: .accessToken
        )
        
        refreshToken = try values.decodeIfPresent(
            String.self,
            forKey: .refreshToken
        )
        
        idToken = try values.decodeIfPresent(
            String.self,
            forKey: .idToken
        )
        
        tokenType = try values.decode(
            String.self,
            forKey: .tokenType
        )
        
        let expiresIn = try values.decode(
            Double.self,
            forKey: .expiresIn
        )
        expiryDate = Date(timeIntervalSinceNow: expiresIn)
    }
}
