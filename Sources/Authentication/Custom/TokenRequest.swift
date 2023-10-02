struct TokenRequest: Codable {
    let authorizationCode: String
    
    enum CodingKeys: String, CodingKey {
        case authorizationCode = "code"
    }
}
