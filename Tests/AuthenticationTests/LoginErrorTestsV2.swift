@testable import Authentication
import XCTest

final class LoginErrorV2Tests: XCTestCase {
    var sut: LoginErrorV2!
}

extension LoginErrorV2Tests {
    func test_localizedDescription() throws {
        // General Error Domain
        sut = LoginErrorV2(reason: .userCancelled, underlyingReason: "test user cancelled")
        XCTAssertEqual(sut.errorDescription, "test user cancelled")
        sut = LoginErrorV2(reason: .network, underlyingReason: "test network")
        XCTAssertEqual(sut.errorDescription, "test network")
        sut = LoginErrorV2(reason: .generalServerError, underlyingReason: "test server error")
        XCTAssertEqual(sut.errorDescription, "test server error")
        sut = LoginErrorV2(reason: .safariOpenError, underlyingReason: "test server error")
        XCTAssertEqual(sut.errorDescription, "test server error")
        
        // Authorization Error Domain
        sut = LoginErrorV2(reason: .authorizationInvalidRequest, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationUnauthorizedClient, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationAccessDenied, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationUnsupportedResponseType, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationInvalidScope, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationServerError, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationTemporarilyUnavailable, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationClientError, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .authorizationUnknownError, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        
        // Token Error Domain
        sut = LoginErrorV2(reason: .tokenInvalidRequest, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenUnauthorizedClient, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenInvalidScope, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenInvalidClient, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenInvalidGrant, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenUnsupportedGrantType, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        sut = LoginErrorV2(reason: .tokenClientError, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
        
        // Misc Error
        sut = LoginErrorV2(reason: .unknownError, underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
        sut = LoginErrorV2(reason: .generic(description: ""), underlyingReason: "test authorization server error")
        XCTAssertEqual(sut.errorDescription, "test authorization server error")
    }
}
