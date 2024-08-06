import AppAuthCore

// swiftlint:disable type_name
public class MockOIDExternalUserAgentSession_ServerError: NSObject,
                                                          OIDExternalUserAgentSession {
// swiftlint:enable type_name
    var callback: OIDAuthStateAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let authState: OIDAuthState? = nil
        let error: Error? = NSError(domain: OIDOAuthAuthorizationErrorDomain, code: -7)
        callback?(authState, error)
        return true
    }
}
