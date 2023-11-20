import Foundation

struct TokenRequest {
    let authorizationCode: String
    let redirectURI: String
    
    var formEncoded: Data {
        "grant_type=authorization_code&code=\(authorizationCode)&redirect_uri=\(redirectURI)".data(using: .utf8)!
    }
}
