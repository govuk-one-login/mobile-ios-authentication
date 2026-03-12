import AppAuthCore

extension OIDAuthorizationResponse {
    static func mock(mockTokenRequest: OIDTokenRequest? = .mockTokenRequest) -> OIDAuthorizationResponse {
        return MockAuthorizationResponse(tokenExchangeRequest: mockTokenRequest)
    }
}

class MockAuthorizationResponse: OIDAuthorizationResponse {
        
    let tokenExchangeRequest: OIDTokenRequest?
    
    init(tokenExchangeRequest: OIDTokenRequest?) {
        self.tokenExchangeRequest = tokenExchangeRequest
        super.init(request: OIDAuthorizationRequest.mockAuthorizationRequest, parameters: [:])
    }
    
    required init?(coder: NSCoder) {
        self.tokenExchangeRequest = nil
        super.init(coder: coder)
    }
    
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
        return tokenExchangeRequest
    }
}
