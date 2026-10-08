import AppAuthCore

class MockOIDExternalUserAgentSessionResumeFalseWithoutCallback: NSObject,
                                             OIDExternalUserAgentSession {
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        return false
    }
}
