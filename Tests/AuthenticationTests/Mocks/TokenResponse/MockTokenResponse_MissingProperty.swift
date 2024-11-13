import AppAuthCore

class MockTokenResponse_MissingProperty: OIDTokenResponse {
    override var accessToken: String? {
        nil
    }
    
    override var tokenType: String? {
        "mock token"
    }
    
    override var refreshToken: String? {
        "0987654321"
    }
    
    override var idToken: String? {
        "mock user"
    }
    
    override var accessTokenExpirationDate: Date? {
        Date()
    }
}
