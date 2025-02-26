import AppAuthCore

class MockOIDExternalUserAgentSession_AccessDenied: NSObject,
                                                    OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let error: Error? = NSError(
            domain: OIDOAuthAuthorizationErrorDomain,
            code: -4
        )
        callback?(nil, error)
        return true
    }
}
