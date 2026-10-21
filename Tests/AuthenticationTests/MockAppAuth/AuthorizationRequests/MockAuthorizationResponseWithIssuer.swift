@preconcurrency import AppAuthCore

final class MockAuthorizationResponseWithIssuer: OIDAuthorizationResponse {
    let issuer: URL?

    init(issuer: URL?) {
        self.issuer = issuer
        super.init(request: OIDAuthorizationRequest.mock(), parameters: [:])
    }

    required init?(coder: NSCoder) {
        self.issuer = nil
        super.init(coder: coder)
    }

    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
        return .mock(issuer: issuer,
                     withAdditionalParameters: additionalParameters,
                     additionalHeaders: additionalHeaders)
    }
}
