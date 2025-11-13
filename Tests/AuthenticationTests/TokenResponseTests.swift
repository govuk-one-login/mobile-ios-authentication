@testable import Authentication
import Foundation
import Testing

struct Test {
    @Test
    func decodeFullTokenResponse() throws {
        let tokenResponseData = Data("""
        {
            "access_token": "testAccessTokenResponse",
            "refresh_token": "testRefreshTokenResponse",
            "id_token": "testIDTokenResponse",
            "token_type": "token",
            "expires_in": 180
        }
        """.utf8)
        let decodedToken = try JSONDecoder()
            .decode(TokenResponse.self, from: tokenResponseData)
        #expect(decodedToken.accessToken == "testAccessTokenResponse")
        #expect(decodedToken.refreshToken == "testRefreshTokenResponse")
        #expect(decodedToken.idToken == "testIDTokenResponse")
        #expect(decodedToken.tokenType == "token")
        #expect(decodedToken.expiryDate.description == Date(timeIntervalSinceNow: 180).description)
    }
    
    @Test
    func decodePartialTokenResponse() throws {
        let tokenResponseData = Data("""
        {
            "access_token": "testAccessTokenResponse",
            "token_type": "token",
            "expires_in": 180
        }
        """.utf8)
        let decodedToken = try JSONDecoder()
            .decode(TokenResponse.self, from: tokenResponseData)
        #expect(decodedToken.accessToken == "testAccessTokenResponse")
        #expect(decodedToken.refreshToken == nil)
        #expect(decodedToken.idToken == nil)
        #expect(decodedToken.tokenType == "token")
        #expect(decodedToken.expiryDate.description == Date(timeIntervalSinceNow: 180).description)
    }
}
