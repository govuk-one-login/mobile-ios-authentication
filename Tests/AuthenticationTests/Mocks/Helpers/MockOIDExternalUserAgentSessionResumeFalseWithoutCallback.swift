import AppAuthCore

// swiftlint:disable:next type_name
final class MockOIDExternalUserAgentSessionResumeFalseWithoutCallback: NSObject,
                                                                       Sendable,
                                                                       OIDExternalUserAgentSession {
    final class FailExternalUserAgentFlowErrors: Sequence<Error> {

        func makeIterator() -> IndexingIterator<Array<Error>> {
            self.errors.makeIterator()
        }

        typealias Iterator = IndexingIterator<Array<Error>>

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

        return MockOIDExternalUserAgentSessionResumeFalseWithoutCallback(failExternalUserAgentFlowWithErrorAsFunction: failExternalUserAgentFlowWithErrorAsFunction)
    }

    typealias FailExternalUserAgentFlowWithErrorAsFunction = @Sendable (Error) -> ()

    private let failExternalUserAgentFlowWithErrorAsFunction: FailExternalUserAgentFlowWithErrorAsFunction

    init(failExternalUserAgentFlowWithErrorAsFunction: @escaping FailExternalUserAgentFlowWithErrorAsFunction = { error in }) {
        self.failExternalUserAgentFlowWithErrorAsFunction = failExternalUserAgentFlowWithErrorAsFunction
    }

    public func cancel() { }

    public func cancel() async { }

    public func failExternalUserAgentFlowWithError(_ error: Error) {
        self.failExternalUserAgentFlowWithErrorAsFunction(error)
    }

    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        return false
    }
}
