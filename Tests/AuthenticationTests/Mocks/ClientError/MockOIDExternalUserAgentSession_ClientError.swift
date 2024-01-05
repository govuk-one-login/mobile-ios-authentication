import AppAuthCore

public class MockOIDExternalUserAgentSession_ClientError: NSObject,
                                                          OIDExternalUserAgentSession {
    var callback: OIDAuthStateAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let authState: OIDAuthState? = nil
        let error: Error? = NSError(domain: OIDOAuthAuthorizationErrorDomain, code: -61439)
        callback?(authState, error)
        return true
    }
}
