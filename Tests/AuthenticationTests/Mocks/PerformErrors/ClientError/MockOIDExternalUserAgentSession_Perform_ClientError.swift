import AppAuthCore

// swiftlint:disable:next type_name
class MockOIDExternalUserAgentSession_Perform_ClientError: NSObject,
                                                           OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let authorizationResponse = MockAuthorizationResponse(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )
        
        callback?(authorizationResponse, nil)
        return true
    }
}

class MockAuthorizationResponse: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
        return OIDTokenRequest.mockTokenRequest
    }
}
