import AppAuthCore

// swiftlint:disable:next type_name
public class MockOIDExternalUserAgentSession_TokenInvalidRequest: NSObject,
                                                                  OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let error: Error? = NSError(
            domain: OIDOAuthTokenErrorDomain,
            code: -2
        )
        callback?(nil, error)
        return true
    }
}
