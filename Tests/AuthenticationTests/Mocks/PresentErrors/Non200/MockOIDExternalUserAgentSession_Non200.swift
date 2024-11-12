import AppAuthCore

final class MockOIDExternalUserAgentSession_Non200: NSObject,
                                                    OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let error: Error? = NSError(
            domain: OIDGeneralErrorDomain,
            code: -6
        )
        callback?(nil, error)
        return true
    }
}
