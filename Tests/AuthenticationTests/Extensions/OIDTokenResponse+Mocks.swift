@preconcurrency import AppAuthCore

extension OIDTokenResponse {
    static func mock(request: OIDTokenRequest = .mock()) -> MockTokenResponse {
        return MockTokenResponse(request: request, parameters: [:])
    }

    static func mock(accessToken: String? = nil,
                     tokenType: String? = "mock token",
                     refreshToken: String? = "0987654321",
                     idToken: String? = "mock user",
                     accessTokenExpirationDate: Date? = Date()) -> MockTokenResponse {
        return MockTokenResponse(response: MockTokenResponse.Response(
            accessToken:accessToken,
            tokenType: tokenType,
            refreshToken: refreshToken,
            idToken: idToken,
            accessTokenExpirationDate: accessTokenExpirationDate))
    }
}
