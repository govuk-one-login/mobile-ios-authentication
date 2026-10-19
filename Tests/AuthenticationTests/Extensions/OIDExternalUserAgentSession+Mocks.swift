@preconcurrency import AppAuthCore

extension OIDExternalUserAgentSession {
    /// Use this ``OIDExternalUserAgentSession`` with a response for a succesful resume on the user agent session
    /// - Parameter authorizationResponse: the response with which the `OIDExternalUserAgentSession` will callback with when a call to ``resumeExternalUserAgentFlow(with:)`` is made.
    /// - SeeAlso: ``OIDAuthorizationResponse/mock(tokenExchangeRequest:)`` for a response with a given token request
    /// - SeeAlso: ``OIDAuthorizationResponse/mock(issuer:)`` for a response with a given issuer
    @MainActor
    static func mockResumeExternalUserAgentFlowWith(authorizationResponse: OIDAuthorizationResponse = .mock(tokenExchangeRequest: .mock())) -> MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow {
        return MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow(authorizationResponse: authorizationResponse)
    }

    /// Use this ``OIDExternalUserAgentSession`` with an error that fails to resume the user agent session
    /// - Parameter error: the error with which the `OIDExternalUserAgentSession` will callback with when a call to ``resumeExternalUserAgentFlow(with:)`` is made.
    /// - SeeAlso: ``OIDError`` for a list of possible errors
    @MainActor
    static func mockResumeExternalUserAgentFlowWith(error: any Error) -> MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow {
        return MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow(
            error: error
        )
    }
}
