import AppAuthCore

final class MockTokenResponse_FullyFormed: OIDTokenResponse {
    override var accessToken: String? {
        "1234567890"
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
