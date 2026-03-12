import AppAuthCore

extension OIDExternalUserAgentSession {
    
    static func mock(authorizationResponse: OIDAuthorizationResponse = .mock()) -> MockOIDExternalUserAgentSession_Success {
        return MockOIDExternalUserAgentSession_Success(authorizationResponse: authorizationResponse)
    }
}

class MockOIDExternalUserAgentSession_Success: NSObject,
                                               OIDExternalUserAgentSession {
    
    var authorizationResponse: OIDAuthorizationResponse?
    var callback: OIDAuthorizationCallback?

    init(authorizationResponse: OIDAuthorizationResponse? = .mock()) {
        self.authorizationResponse = authorizationResponse
    }
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(self.authorizationResponse, nil)
        return true
    }
}
