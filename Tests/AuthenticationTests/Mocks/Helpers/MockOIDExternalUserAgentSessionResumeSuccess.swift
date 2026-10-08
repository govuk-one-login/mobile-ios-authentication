import AppAuthCore

extension OIDExternalUserAgentSession {
    
    static func mock(authorizationResponse: OIDAuthorizationResponse = .mock()) -> MockOIDExternalUserAgentSessionResumeSuccess {
        return MockOIDExternalUserAgentSessionResumeSuccess(authorizationResponse: authorizationResponse)
    }

    /// Use this ``OIDExternalUserAgentSession`` with an error that indicates the call to ``resumeExternalUserAgentFlow(with:)`` for the same instance of the user agent session can be retried with a different URL
    static func mockURLMismatch() -> MockOIDExternalUserAgentSessionResumeError {
        return MockOIDExternalUserAgentSessionResumeError(error: OIDError.error(code: .urlMismatch))
    }

    /// Use this ``OIDExternalUserAgentSession`` with an error that indicates a call to ``resumeExternalUserAgentFlow(with:)``will consistently and permanently fail for the same
    /// instance of the user agent session. This indicates a programmatic error.
    static func mockInvalidAuthorizationFlow() -> MockOIDExternalUserAgentSessionResumeError {
        return MockOIDExternalUserAgentSessionResumeError(error: OIDError.error(code: .invalidAuthorizationFlow))
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
