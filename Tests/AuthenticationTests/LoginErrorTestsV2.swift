@testable import Authentication
import XCTest

final class LoginErrorV2Tests: XCTestCase {
    var sut: LoginErrorV2!
}

extension LoginErrorV2Tests {
    func test_localizedDescription() throws {
        // General Error Domain
        sut = LoginErrorV2(reason: .userCancelled, underlyingReason: "test user cancelled error")
        XCTAssertEqual(sut.errorDescription, "test user cancelled error")
        sut = LoginErrorV2(reason: .network, underlyingReason: "test network error")
        XCTAssertEqual(sut.errorDescription, "test network error")
        sut = LoginErrorV2(reason: .generalServerError, underlyingReason: "test server error")
        XCTAssertEqual(sut.errorDescription, "test server error")
        sut = LoginErrorV2(reason: .safariOpenError, underlyingReason: "test safari open error")
        XCTAssertEqual(sut.errorDescription, "test safari open error")
        
        // Authorization Error Domain
        sut = LoginErrorV2(reason: .authorizationInvalidRequest, underlyingReason: "test authorization invalid request error")
        XCTAssertEqual(sut.errorDescription, "test authorization invalid request error")
        sut = LoginErrorV2(reason: .authorizationUnauthorizedClient, underlyingReason: "test authorization unauthorized client error")
        XCTAssertEqual(sut.errorDescription, "test authorization unauthorized client error")
        sut = LoginErrorV2(reason: .authorizationAccessDenied, underlyingReason: "test authorization access denied error")
        XCTAssertEqual(sut.errorDescription, "test authorization access denied error")
        sut = LoginErrorV2(reason: .authorizationUnsupportedResponseType, underlyingReason: "test authorization unsupported response type error")
        XCTAssertEqual(sut.errorDescription, "test authorization unsupported response type error")
        sut = LoginErrorV2(reason: .authorizationInvalidScope, underlyingReason: "test authorization invalid scope error")
        XCTAssertEqual(sut.errorDescription, "test authorization invalid scope error")
        sut = LoginErrorV2(reason: .authorizationServerError, underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
        sut = LoginErrorV2(reason: .authorizationTemporarilyUnavailable, underlyingReason: "test authorization temporarily unavailable error")
        XCTAssertEqual(sut.errorDescription, "test authorization temporarily unavailable error")
        sut = LoginErrorV2(reason: .authorizationClientError, underlyingReason: "test authorization client error")
        XCTAssertEqual(sut.errorDescription, "test authorization client error")
        sut = LoginErrorV2(reason: .authorizationUnknownError, underlyingReason: "test authorization unknown error")
        XCTAssertEqual(sut.errorDescription, "test authorization unknown error")
        
        // Token Error Domain
        sut = LoginErrorV2(reason: .tokenInvalidRequest, underlyingReason: "test token invalid request error")
        XCTAssertEqual(sut.errorDescription, "test token invalid request error")
        sut = LoginErrorV2(reason: .tokenUnauthorizedClient, underlyingReason: "test token unauthorized client error")
        XCTAssertEqual(sut.errorDescription, "test token unauthorized client error")
        sut = LoginErrorV2(reason: .tokenInvalidScope, underlyingReason: "test token invalid scope error")
        XCTAssertEqual(sut.errorDescription, "test token invalid scope error")
        sut = LoginErrorV2(reason: .tokenInvalidClient, underlyingReason: "test token invalied client error")
        XCTAssertEqual(sut.errorDescription, "test token invalied client error")
        sut = LoginErrorV2(reason: .tokenInvalidGrant, underlyingReason: "test token invalid grant error")
        XCTAssertEqual(sut.errorDescription, "test token invalid grant error")
        sut = LoginErrorV2(reason: .tokenUnsupportedGrantType, underlyingReason: "test token unsupported grant type error")
        XCTAssertEqual(sut.errorDescription, "test token unsupported grant type error")
        sut = LoginErrorV2(reason: .tokenClientError, underlyingReason: "test token client error")
        XCTAssertEqual(sut.errorDescription, "test token client error")
        sut = LoginErrorV2(reason: .tokenUnknownError, underlyingReason: "test token unknown error")
        XCTAssertEqual(sut.errorDescription, "test token unknown error")
        
        // Misc Error
        sut = LoginErrorV2(reason: .generic(description: "some generic description"), underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
        XCTAssertEqual(sut.reason, .generic(description: "some generic description"))
    }
}
