import AppAuthCore

class MockAuthorizationResponse: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
        return OIDTokenRequest.mockTokenRequest
    }
}
