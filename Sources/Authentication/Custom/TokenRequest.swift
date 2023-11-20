import Foundation

struct TokenRequest: Codable {
    let authorizationCode: String
    let grantType: String = "authorization_code"
    let redirectURI: String
    
    enum CodingKeys: String, CodingKey {
        case authorizationCode = "code"
        case grantType = "grant_type"
        case redirectURI = "redirect_uri"
    }
    
    var formEncoded: Data {
        "grant_type=\(grantType)&code=\(authorizationCode)&redirect_uri=\(redirectURI)".data(using: .utf8)!
    }
}
