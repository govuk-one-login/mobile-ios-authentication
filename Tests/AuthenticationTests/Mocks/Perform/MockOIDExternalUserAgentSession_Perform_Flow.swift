import AppAuthCore

class MockOIDExternalUserAgentSession_Perform_Flow: NSObject,
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
