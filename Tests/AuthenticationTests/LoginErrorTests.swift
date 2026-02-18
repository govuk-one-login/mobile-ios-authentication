@testable import Authentication
import XCTest

final class LoginErrorTests: XCTestCase {
    var sut: LoginError!
}

extension LoginErrorTests {
    func test_localizedDescription() throws {
        // General Error Domain
        sut = LoginError(reason: .userCancelled, underlyingReason: "test user cancelled error")
        XCTAssertEqual(sut.errorDescription, "test user cancelled error")
        sut = LoginError(reason: .network, underlyingReason: "test network error")
        XCTAssertEqual(sut.errorDescription, "test network error")
        sut = LoginError(reason: .generalServerError, underlyingReason: "test server error")
        XCTAssertEqual(sut.errorDescription, "test server error")
        sut = LoginError(reason: .safariOpenError, underlyingReason: "test safari open error")
        XCTAssertEqual(sut.errorDescription, "test safari open error")
        
        // Authorization Error Domain
        sut = LoginError(reason: .authorizationInvalidRequest, underlyingReason: "test authorization invalid request error")
        XCTAssertEqual(sut.errorDescription, "test authorization invalid request error")
        sut = LoginError(reason: .authorizationUnauthorizedClient, underlyingReason: "test authorization unauthorized client error")
        XCTAssertEqual(sut.errorDescription, "test authorization unauthorized client error")
        sut = LoginError(reason: .authorizationAccessDenied, underlyingReason: "test authorization access denied error")
        XCTAssertEqual(sut.errorDescription, "test authorization access denied error")
        sut = LoginError(reason: .authorizationUnsupportedResponseType, underlyingReason: "test authorization unsupported response type error")
        XCTAssertEqual(sut.errorDescription, "test authorization unsupported response type error")
        sut = LoginError(reason: .authorizationInvalidScope, underlyingReason: "test authorization invalid scope error")
        XCTAssertEqual(sut.errorDescription, "test authorization invalid scope error")
        sut = LoginError(reason: .authorizationServerError, underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
        sut = LoginError(reason: .authorizationTemporarilyUnavailable, underlyingReason: "test authorization temporarily unavailable error")
        XCTAssertEqual(sut.errorDescription, "test authorization temporarily unavailable error")
        sut = LoginError(reason: .authorizationClientError, underlyingReason: "test authorization client error")
        XCTAssertEqual(sut.errorDescription, "test authorization client error")
        sut = LoginError(reason: .authorizationUnknownError, underlyingReason: "test authorization unknown error")
        XCTAssertEqual(sut.errorDescription, "test authorization unknown error")
        
        // Token Error Domain
        sut = LoginError(reason: .tokenInvalidRequest, underlyingReason: "test token invalid request error")
        XCTAssertEqual(sut.errorDescription, "test token invalid request error")
        sut = LoginError(reason: .tokenUnauthorizedClient, underlyingReason: "test token unauthorized client error")
        XCTAssertEqual(sut.errorDescription, "test token unauthorized client error")
        sut = LoginError(reason: .tokenInvalidScope, underlyingReason: "test token invalid scope error")
        XCTAssertEqual(sut.errorDescription, "test token invalid scope error")
        sut = LoginError(reason: .tokenInvalidClient, underlyingReason: "test token invalied client error")
        XCTAssertEqual(sut.errorDescription, "test token invalied client error")
        sut = LoginError(reason: .tokenInvalidGrant, underlyingReason: "test token invalid grant error")
        XCTAssertEqual(sut.errorDescription, "test token invalid grant error")
        sut = LoginError(reason: .tokenUnsupportedGrantType, underlyingReason: "test token unsupported grant type error")
        XCTAssertEqual(sut.errorDescription, "test token unsupported grant type error")
        sut = LoginError(reason: .tokenClientError, underlyingReason: "test token client error")
        XCTAssertEqual(sut.errorDescription, "test token client error")
        sut = LoginError(reason: .tokenUnknownError, underlyingReason: "test token unknown error")
        XCTAssertEqual(sut.errorDescription, "test token unknown error")
        
        // Misc Error
        sut = LoginError(reason: .generic(description: "some generic description"), underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
        XCTAssertEqual(sut.reason, .generic(description: "some generic description"))
    }
}
