import AppAuthCore

class MockAuthorizationResponse_MissingTokenRequest: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
        nil
    }
}
