@testable import Authentication
import Testing

struct LoginErrorTests {
}

extension LoginErrorTests {

    // swiftlint:disable line_length
    static let allLoginErrors = [
        (error: LoginError(.userCancelled, reason: "test user cancelled error"), debugDescription: "test user cancelled error"),
        (error: LoginError(.network, reason: "test network error"), debugDescription: "test network error"),
        (error: LoginError(.generalServerError, reason: "test server error"), debugDescription: "test server error"),
        (error: LoginError(.safariOpenError, reason: "test safari open error"), debugDescription: "test safari open error"),
        (error: LoginError(.authorizationInvalidRequest, reason: "test authorization invalid request error"), debugDescription: "test authorization invalid request error"),
        (error: LoginError(.authorizationUnauthorizedClient, reason: "test authorization unauthorized client error"), debugDescription: "test authorization unauthorized client error"),
        (error: LoginError(.authorizationAccessDenied, reason: "test authorization access denied error"), debugDescription: "test authorization access denied error"),
        (error: LoginError(.authorizationUnsupportedResponseType, reason: "test authorization unsupported response type error"), debugDescription: "test authorization unsupported response type error"),
        (error: LoginError(.authorizationInvalidScope, reason: "test authorization invalid scope error"), debugDescription: "test authorization invalid scope error"),
        (error: LoginError(.authorizationServerError, reason: "test authorization server error"), debugDescription: "test authorization server error"),
        (error: LoginError(.authorizationTemporarilyUnavailable, reason: "test authorization temporarily unavailable error"), debugDescription: "test authorization temporarily unavailable error"),
        (error: LoginError(.authorizationClientError, reason: "test authorization client error"), debugDescription: "test authorization client error"),
        (error: LoginError(.authorizationUnknownError, reason: "test authorization unknown error"), debugDescription: "test authorization unknown error"),
        (error: LoginError(.tokenInvalidRequest, reason: "test token invalid request error"), debugDescription: "test token invalid request error"),
        (error: LoginError(.tokenUnauthorizedClient, reason: "test token unauthorized client error"), debugDescription: "test token unauthorized client error"),
        (error: LoginError(.tokenInvalidScope, reason: "test token invalid scope error"), debugDescription: "test token invalid scope error"),
        (error: LoginError(.tokenInvalidClient, reason: "test token invalied client error"), debugDescription: "test token invalied client error"),
        (error: LoginError(.tokenInvalidGrant, reason: "test token invalid grant error"), debugDescription: "test token invalid grant error"),
        (error: LoginError(.tokenUnsupportedGrantType, reason: "test token unsupported grant type error"), debugDescription: "test token unsupported grant type error"),
        (error: LoginError(.tokenClientError, reason: "test token client error"), debugDescription: "test token client error"),
        (error: LoginError(.tokenUnknownError, reason: "test token unknown error"), debugDescription: "test token unknown error"),
        (error: LoginError(.generic, reason: "test authorization server error"), debugDescription: "test authorization server error")]
    // swiftlint:enable line_length
    
    @Test("assert debugDescription matches reason", arguments: LoginErrorTests.allLoginErrors)
    func test_debugDescription(sut: LoginError, debugDescription: String) async throws {
        #expect(sut.debugDescription == debugDescription)
    }
}
