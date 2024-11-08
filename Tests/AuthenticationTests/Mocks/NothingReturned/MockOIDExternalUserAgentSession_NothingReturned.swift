import AppAuthCore

public class MockOIDExternalUserAgentSession_NothingReturned: NSObject,
                                                              OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(nil, nil)
        return true
    }
}
