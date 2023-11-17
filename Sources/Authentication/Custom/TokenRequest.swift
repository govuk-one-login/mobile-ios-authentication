struct TokenRequest: Codable {
    let authorizationCode: String
    let grantType: String = "authorization_code"
    let redirectURI: String
    
    enum CodingKeys: String, CodingKey {
        case authorizationCode = "code"
        case grantType = "grant_type"
        case redirectURI = "redirect_uri"
    }
}
