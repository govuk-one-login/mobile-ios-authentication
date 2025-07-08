import AppAuthCore

// swiftlint:disable:next type_name
class MockOIDExternalUserAgentSession_AuthorizationInvalidRequestError: NSObject,
                                                                   OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(
            nil,
            NSError(
                domain: OIDOAuthAuthorizationErrorDomain,
                code: -2
            )
        )
        return true
    }
}
