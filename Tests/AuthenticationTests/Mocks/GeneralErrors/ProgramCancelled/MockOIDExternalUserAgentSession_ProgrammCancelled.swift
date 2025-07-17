import AppAuthCore

class MockOIDExternalUserAgentSession_ProgramCancelled: NSObject,
                                                         OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(
            nil,
            NSError(
                domain: OIDGeneralErrorDomain,
                code: -4
            )
        )
        return true
    }
}
