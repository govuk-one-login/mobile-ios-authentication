@testable import Authentication
import Testing

struct LoginErrorTests {
}

extension LoginErrorTests {

    struct Case: Sendable {
        let error: LoginError
        let debugDescription: String
        let kind: String
    }
    
    static let allLoginErrors = [
        // swiftlint:disable line_length
        Case(error: LoginError(.generic), debugDescription: "Error Domain=LoginErrorKind Code=1000 \"generic\"", kind: "generic"),
        Case(error: LoginError(.invalidRedirectURL), debugDescription: "Error Domain=LoginErrorKind Code=1001 \"invalidRedirectURL\"", kind: "invalidRedirectURL"),
        Case(error: LoginError(.userCancelled), debugDescription: "Error Domain=LoginErrorKind Code=2001 \"userCancelled\"", kind: "userCancelled"),
        Case(error: LoginError(.programCancelled), debugDescription: "Error Domain=LoginErrorKind Code=2002 \"programCancelled\"", kind: "programCancelled"),
        Case(error: LoginError(.network), debugDescription: "Error Domain=LoginErrorKind Code=2003 \"network\"", kind: "network"),
        Case(error: LoginError(.generalServerError), debugDescription: "Error Domain=LoginErrorKind Code=2004 \"generalServerError\"", kind: "generalServerError"),
        Case(error: LoginError(.safariOpenError), debugDescription: "Error Domain=LoginErrorKind Code=2005 \"safariOpenError\"", kind: "safariOpenError"),
        Case(error: LoginError(.authorizationInvalidRequest), debugDescription: "Error Domain=LoginErrorKind Code=3001 \"authorizationInvalidRequest\"", kind: "authorizationInvalidRequest"),
        Case(error: LoginError(.authorizationUnauthorizedClient), debugDescription: "Error Domain=LoginErrorKind Code=3002 \"authorizationUnauthorizedClient\"", kind: "authorizationUnauthorizedClient"),
        Case(error: LoginError(.authorizationAccessDenied), debugDescription: "Error Domain=LoginErrorKind Code=3003 \"authorizationAccessDenied\"", kind: "authorizationAccessDenied"),
        Case(error: LoginError(.authorizationUnsupportedResponseType), debugDescription: "Error Domain=LoginErrorKind Code=3004 \"authorizationUnsupportedResponseType\"", kind: "authorizationUnsupportedResponseType"),
        Case(error: LoginError(.authorizationInvalidScope), debugDescription: "Error Domain=LoginErrorKind Code=3005 \"authorizationInvalidScope\"", kind: "authorizationInvalidScope"),
        Case(error: LoginError(.authorizationServerError), debugDescription: "Error Domain=LoginErrorKind Code=3006 \"authorizationServerError\"", kind: "authorizationServerError"),
        Case(error: LoginError(.authorizationTemporarilyUnavailable), debugDescription: "Error Domain=LoginErrorKind Code=3007 \"authorizationTemporarilyUnavailable\"", kind: "authorizationTemporarilyUnavailable"),
        Case(error: LoginError(.authorizationClientError), debugDescription: "Error Domain=LoginErrorKind Code=3008 \"authorizationClientError\"", kind: "authorizationClientError"),
        Case(error: LoginError(.authorizationUnknownError), debugDescription: "Error Domain=LoginErrorKind Code=3100 \"authorizationUnknownError\"", kind: "authorizationUnknownError"),
        Case(error: LoginError(.tokenInvalidRequest), debugDescription: "Error Domain=LoginErrorKind Code=4001 \"tokenInvalidRequest\"", kind: "tokenInvalidRequest"),
        Case(error: LoginError(.tokenUnauthorizedClient), debugDescription: "Error Domain=LoginErrorKind Code=4002 \"tokenUnauthorizedClient\"", kind: "tokenUnauthorizedClient"),
        Case(error: LoginError(.tokenInvalidScope), debugDescription: "Error Domain=LoginErrorKind Code=4003 \"tokenInvalidScope\"", kind: "tokenInvalidScope"),
        Case(error: LoginError(.tokenInvalidClient), debugDescription: "Error Domain=LoginErrorKind Code=4004 \"tokenInvalidClient\"", kind: "tokenInvalidClient"),
        Case(error: LoginError(.tokenInvalidGrant), debugDescription: "Error Domain=LoginErrorKind Code=4005 \"tokenInvalidGrant\"", kind: "tokenInvalidGrant"),
        Case(error: LoginError(.tokenUnsupportedGrantType), debugDescription: "Error Domain=LoginErrorKind Code=4006 \"tokenUnsupportedGrantType\"", kind: "tokenUnsupportedGrantType"),
        Case(error: LoginError(.tokenClientError), debugDescription: "Error Domain=LoginErrorKind Code=4007 \"tokenClientError\"", kind: "tokenClientError"),
        Case(error: LoginError(.tokenUnknownError), debugDescription: "Error Domain=LoginErrorKind Code=4100 \"tokenUnknownError\"", kind: "tokenUnknownError")]
        // swiftlint:enable line_length

    @Test("assert debugDescription", arguments: allLoginErrors)
    func test_debugDescription(testCase: Case) async throws {
        #expect(testCase.error.debugDescription == testCase.debugDescription)
    }
    
    /// // swiftlint:disable line_length
    /// The `kind` found in the `userInfo` **must** hold a unique String identifier that describes the error as reported on analytics
    /// - Seealso: https://govukverify.atlassian.net/wiki/spaces/DCMAW/pages/3787195450/GOV.UK+One+Login+app+-+Error+handling#Authentication-errors-(appAuth-mappings)
    /// // swiftlint:enable line_length
    @Test("assert kind", arguments: LoginErrorTests.allLoginErrors)
    func test_kind(testCase: Case) async throws {
        #expect(testCase.error.errorUserInfo["kind"] as? String == testCase.kind)
    }
}
