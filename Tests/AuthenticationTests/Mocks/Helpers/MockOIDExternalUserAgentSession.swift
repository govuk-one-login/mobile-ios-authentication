import AppAuthCore

class MockOIDExternalUserAgentSession: NSObject,
                                       OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    var allowsResume = true

    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        guard allowsResume else {
            return false
        }
        let authorizationResponse = MockAuthorizationResponse(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )
        
        callback?(authorizationResponse, nil)
        return allowsResume
    }
}
