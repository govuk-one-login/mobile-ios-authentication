@testable import Authentication
import XCTest

final class LoginErrorTests: XCTestCase {
    var sut: LoginError!
}

extension LoginErrorTests {
    func test_localizedDescription() throws {
        // General Error Domain
        sut = LoginError(.userCancelled, reason: "test user cancelled error")
        XCTAssertEqual(sut!.debugDescription, "test user cancelled error")
        sut = LoginError(.network, reason: "test network error")
        XCTAssertEqual(sut!.debugDescription, "test network error")
        sut = LoginError(.generalServerError, reason: "test server error")
        XCTAssertEqual(sut!.debugDescription, "test server error")
        sut = LoginError(.safariOpenError, reason: "test safari open error")
        XCTAssertEqual(sut!.debugDescription, "test safari open error")
        
        // Authorization Error Domain
        sut = LoginError(.authorizationInvalidRequest, reason: "test authorization invalid request error")
        XCTAssertEqual(sut!.debugDescription, "test authorization invalid request error")
        sut = LoginError(.authorizationUnauthorizedClient, reason: "test authorization unauthorized client error")
        XCTAssertEqual(sut!.debugDescription, "test authorization unauthorized client error")
        sut = LoginError(.authorizationAccessDenied, reason: "test authorization access denied error")
        XCTAssertEqual(sut!.debugDescription, "test authorization access denied error")
        sut = LoginError(.authorizationUnsupportedResponseType, reason: "test authorization unsupported response type error")
        XCTAssertEqual(sut!.debugDescription, "test authorization unsupported response type error")
        sut = LoginError(.authorizationInvalidScope, reason: "test authorization invalid scope error")
        XCTAssertEqual(sut!.debugDescription, "test authorization invalid scope error")
        sut = LoginError(.authorizationServerError, reason: "test authorization server error")
        XCTAssertEqual(sut!.debugDescription, "test authorization server error")
        sut = LoginError(.authorizationTemporarilyUnavailable, reason: "test authorization temporarily unavailable error")
        XCTAssertEqual(sut!.debugDescription, "test authorization temporarily unavailable error")
        sut = LoginError(.authorizationClientError, reason: "test authorization client error")
        XCTAssertEqual(sut!.debugDescription, "test authorization client error")
        sut = LoginError(.authorizationUnknownError, reason: "test authorization unknown error")
        XCTAssertEqual(sut!.debugDescription, "test authorization unknown error")
        
        // Token Error Domain
        sut = LoginError(.tokenInvalidRequest, reason: "test token invalid request error")
        XCTAssertEqual(sut!.debugDescription, "test token invalid request error")
        sut = LoginError(.tokenUnauthorizedClient, reason: "test token unauthorized client error")
        XCTAssertEqual(sut!.debugDescription, "test token unauthorized client error")
        sut = LoginError(.tokenInvalidScope, reason: "test token invalid scope error")
        XCTAssertEqual(sut!.debugDescription, "test token invalid scope error")
        sut = LoginError(.tokenInvalidClient, reason: "test token invalied client error")
        XCTAssertEqual(sut!.debugDescription, "test token invalied client error")
        sut = LoginError(.tokenInvalidGrant, reason: "test token invalid grant error")
        XCTAssertEqual(sut!.debugDescription, "test token invalid grant error")
        sut = LoginError(.tokenUnsupportedGrantType, reason: "test token unsupported grant type error")
        XCTAssertEqual(sut!.debugDescription, "test token unsupported grant type error")
        sut = LoginError(.tokenClientError, reason: "test token client error")
        XCTAssertEqual(sut!.debugDescription, "test token client error")
        sut = LoginError(.tokenUnknownError, reason: "test token unknown error")
        XCTAssertEqual(sut!.debugDescription, "test token unknown error")

        // Misc Error
        sut = LoginError(.generic, reason: "test authorization server error")
        XCTAssertEqual(sut!.debugDescription, "test authorization server error")
        XCTAssertEqual(sut!.kind, .generic)
    }
}
