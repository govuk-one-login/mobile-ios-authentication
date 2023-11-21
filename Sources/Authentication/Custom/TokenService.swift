import Foundation
import Networking

public protocol TokenServicing {
    func fetchTokens(authorizationCode: String, redirectURI: String, endpoint: URL) async throws -> TokenResponse
}

public final class TokenService: TokenServicing {
    let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchTokens(authorizationCode: String, redirectURI: String, endpoint: URL) async throws -> TokenResponse {
        let requestBody = TokenRequest(authorizationCode: authorizationCode, redirectURI: redirectURI)
        let data = try await client
            .makeRequest(.tokenRequest(requestBody: requestBody, endpoint: endpoint))
        return try JSONDecoder()
            .decode(TokenResponse.self, from: data)
    }
}
