@preconcurrency import AppAuthCore

// swiftlint:disable:next type_name
final class MockOIDExternalUserAgentSessionResumeFalseWithoutCallback: NSObject,
                                                                       Sendable,
                                                                       MockOIDExternalUserAgentSession {
    final class FailExternalUserAgentFlowErrors: Sequence<Error> {

        func makeIterator() -> IndexingIterator<[Error]> {
            self.errors.makeIterator()
        }

        typealias Iterator = IndexingIterator<[Error]>

        fileprivate var errors: [Error]

        var isEmpty: Bool {
            self.errors.isEmpty
        }

        init(errors: [Error] = []) {
            self.errors = errors
        }

        subscript(index: Int) -> Error {
            get {
                errors[index]
            }
            set {
                errors[index] = newValue
            }
        }

        func append(_ newElement: Error) {
            self.errors.append(newElement)
        }
    }

    static func make(errors: FailExternalUserAgentFlowErrors) -> MockOIDExternalUserAgentSessionResumeFalseWithoutCallback {
        let failExternalUserAgentFlowWithErrorAsFunction: FailExternalUserAgentFlowWithErrorAsFunction = { error in
            errors.append(error)
        }

        let externalUserAgentSession = MockOIDExternalUserAgentSessionResumeFalseWithoutCallback(
            failExternalUserAgentFlowWithErrorAsFunction: failExternalUserAgentFlowWithErrorAsFunction
        )
        
        return externalUserAgentSession
    }

    typealias FailExternalUserAgentFlowWithErrorAsFunction = @Sendable (Error) -> Void

    let failExternalUserAgentFlowWithErrorAsFunction: FailExternalUserAgentFlowWithErrorAsFunction?

    let authorizationResponse: OIDAuthorizationResponse?
    let error: (any Error)?
    var callback: OIDAuthorizationCallback?

    init(
    failExternalUserAgentFlowWithErrorAsFunction: @escaping FailExternalUserAgentFlowWithErrorAsFunction = { _ in },
        authorizationResponse: OIDAuthorizationResponse? = nil,
         error: (any Error)? = nil,
         callback: OIDAuthorizationCallback? = nil) {
        self.failExternalUserAgentFlowWithErrorAsFunction = failExternalUserAgentFlowWithErrorAsFunction
        self.authorizationResponse = authorizationResponse
        self.error = error
        self.callback = callback
    }

    public func cancel() { }

    public func cancel() async { }

    public func failExternalUserAgentFlowWithError(_ error: Error) {
        callback?(nil, error)
        self.failExternalUserAgentFlowWithErrorAsFunction?(error)
    }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        return false
    }
}
