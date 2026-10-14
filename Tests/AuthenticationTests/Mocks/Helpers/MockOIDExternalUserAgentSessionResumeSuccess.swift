import AppAuthCore

extension OIDExternalUserAgentSession {
    
    static func mock(authorizationResponse: OIDAuthorizationResponse = .mock()) -> MockOIDExternalUserAgentSessionResumeSuccess {
        return MockOIDExternalUserAgentSessionResumeSuccess(authorizationResponse: authorizationResponse)
    }

    /// Use this ``OIDExternalUserAgentSession`` with an error that fails to resume the user agent session
    static func mockResumeError(code: OIDErrorCode) -> MockOIDExternalUserAgentSessionResumeError {
        return MockOIDExternalUserAgentSessionResumeError(error: OIDError.error(code: code))
    }
}

class MockOIDExternalUserAgentSessionResumeSuccess: NSObject,
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
