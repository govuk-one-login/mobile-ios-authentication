@preconcurrency import AppAuthCore

extension OIDAuthorizationResponse {
    static func mock(issuer: URL) -> OIDAuthorizationResponse {
        return MockAuthorizationResponseWithIssuer(issuer: issuer)
    }

    static func mock(tokenExchangeRequest: OIDTokenRequest? = .mock()) -> OIDAuthorizationResponse {
        return MockAuthorizationResponse(tokenExchangeRequest: tokenExchangeRequest)
    }
}
