import AppAuth
@testable import Authentication
import Foundation
import Networking

public final class MockTokenService: TokenServicing {
    
    public func fetchTokens(authorizationCode: String, endpoint: URL) async throws -> TokenResponse {
       TokenResponse(accessToken: "1234", refreshToken: "1234", idToken: "1234", tokenType: "1", expiresIn: 1)
    }
}
