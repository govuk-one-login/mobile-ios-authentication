@preconcurrency import AppAuthCore

@MainActor
final class MockOIDExternalUserAgentSessionCancel: NSObject,
                                                   @preconcurrency MockOIDExternalUserAgentSession {

    let authorizationResponse: OIDAuthorizationResponse? = nil
    let error: Error?
    var callback: OIDAuthorizationCallback?

    init(error: Error?, callback: OIDAuthorizationCallback? = nil) {
        self.error = error
        self.callback = callback
    }

    public func cancel() {
        callback?(nil, error)
    }

    public func cancel() async {
        callback?(nil, error)
    }

    public func failExternalUserAgentFlowWithError(_ error: Error) { }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        return true
    }
}
