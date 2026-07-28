@testable import Authentication
import Testing

struct LoginErrorTests {
}

extension LoginErrorTests {

    // swiftlint:disable line_length
    static let allLoginErrors = [
        (error: LoginError(.generic), debugDescription: "Error Domain=LoginErrorKind Code=1000 \"generic\""),
        (error: LoginError(.invalidRedirectURL), debugDescription: "Error Domain=LoginErrorKind Code=1001 \"invalidRedirectURL\""),
        (error: LoginError(.userCancelled), debugDescription: "Error Domain=LoginErrorKind Code=2001 \"userCancelled\""),
        (error: LoginError(.programCancelled), debugDescription: "Error Domain=LoginErrorKind Code=2002 \"programCancelled\""),
        (error: LoginError(.network), debugDescription: "Error Domain=LoginErrorKind Code=2003 \"network\""),
        (error: LoginError(.generalServerError), debugDescription: "Error Domain=LoginErrorKind Code=2004 \"generalServerError\""),
        (error: LoginError(.safariOpenError), debugDescription: "Error Domain=LoginErrorKind Code=2005 \"safariOpenError\""),
        (error: LoginError(.authorizationInvalidRequest), debugDescription: "Error Domain=LoginErrorKind Code=3001 \"authorizationInvalidRequest\""),
        (error: LoginError(.authorizationUnauthorizedClient), debugDescription: "Error Domain=LoginErrorKind Code=3002 \"authorizationUnauthorizedClient\""),
        (error: LoginError(.authorizationAccessDenied), debugDescription: "Error Domain=LoginErrorKind Code=3003 \"authorizationAccessDenied\""),
        (error: LoginError(.authorizationUnsupportedResponseType), debugDescription: "Error Domain=LoginErrorKind Code=3004 \"authorizationUnsupportedResponseType\""),
        (error: LoginError(.authorizationInvalidScope), debugDescription: "Error Domain=LoginErrorKind Code=3005 \"authorizationInvalidScope\""),
        (error: LoginError(.authorizationServerError), debugDescription: "Error Domain=LoginErrorKind Code=3006 \"authorizationServerError\""),
        (error: LoginError(.authorizationTemporarilyUnavailable), debugDescription: "Error Domain=LoginErrorKind Code=3007 \"authorizationTemporarilyUnavailable\""),
        (error: LoginError(.authorizationClientError), debugDescription: "Error Domain=LoginErrorKind Code=3008 \"authorizationClientError\""),
        (error: LoginError(.authorizationUnknownError), debugDescription: "Error Domain=LoginErrorKind Code=3100 \"authorizationUnknownError\""),
        (error: LoginError(.tokenInvalidRequest), debugDescription: "Error Domain=LoginErrorKind Code=4001 \"tokenInvalidRequest\""),
        (error: LoginError(.tokenUnauthorizedClient), debugDescription: "Error Domain=LoginErrorKind Code=4002 \"tokenUnauthorizedClient\""),
        (error: LoginError(.tokenInvalidScope), debugDescription: "Error Domain=LoginErrorKind Code=4003 \"tokenInvalidScope\""),
        (error: LoginError(.tokenInvalidClient), debugDescription: "Error Domain=LoginErrorKind Code=4004 \"tokenInvalidClient\""),
        (error: LoginError(.tokenInvalidGrant), debugDescription: "Error Domain=LoginErrorKind Code=4005 \"tokenInvalidGrant\""),
        (error: LoginError(.tokenUnsupportedGrantType), debugDescription: "Error Domain=LoginErrorKind Code=4006 \"tokenUnsupportedGrantType\""),
        (error: LoginError(.tokenClientError), debugDescription: "Error Domain=LoginErrorKind Code=4007 \"tokenClientError\""),
        (error: LoginError(.tokenUnknownError), debugDescription: "Error Domain=LoginErrorKind Code=4100 \"tokenUnknownError\"")]
    // swiftlint:enable line_length
    
    @Test("assert debugDescription", arguments: LoginErrorTests.allLoginErrors)
    func test_debugDescription(sut: LoginError, debugDescription: String) async throws {
        #expect(sut.debugDescription == debugDescription)
    }
}
