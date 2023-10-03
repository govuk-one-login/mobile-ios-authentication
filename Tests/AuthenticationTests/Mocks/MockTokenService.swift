import Foundation
import Networking
@testable import Authentication

public protocol MockTokenServicing {
    func fetchTokens(authorizationCode: String) async throws -> TokenResponse
}

public final class MockTokenService: MockTokenServicing {
    let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchTokens(authorizationCode: String) async throws -> TokenResponse {
        let requestBody = try JSONEncoder()
            .encode(TokenRequest(authorizationCode: authorizationCode))
        let data = try await client
            .makeRequest(.tokenRequest(body: requestBody))
        return try JSONDecoder()
            .decode(TokenResponse.self, from: data)
    }
}
