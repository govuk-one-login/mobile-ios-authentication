@preconcurrency import AppAuthCore

@MainActor
// swiftlint:disable:next type_name
final class MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow: NSObject,
                                                                        @preconcurrency MockOIDExternalUserAgentSession {

    let authorizationResponse: OIDAuthorizationResponse?
    let error: (any Error)?
    var callback: OIDAuthorizationCallback?

    init(authorizationResponse: OIDAuthorizationResponse? = nil,
         error: (any Error)? = nil) {
        self.authorizationResponse = authorizationResponse
        self.error = error
    }

    public func cancel() { }

    public func cancel() async { }

    public func failExternalUserAgentFlowWithError(_ error: Error) { }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        callback?(self.authorizationResponse, self.error)
        return true
    }
}
