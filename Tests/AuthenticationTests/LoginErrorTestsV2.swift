@testable import Authentication
import XCTest

final class LoginErrorV2Tests: XCTestCase {
    var sut: LoginErrorV2!
}

extension LoginErrorV2Tests {
    func test_localizedDescription() throws {
        sut = LoginErrorV2(reason: .clientError, underlyingReason: "test client error")
        XCTAssertEqual(sut.errorDescription, "test client error")
        sut = LoginErrorV2(reason: .generic(description: "generic error"), underlyingReason: "test generic error")
        XCTAssertEqual(sut.errorDescription, "test generic error")
        sut = LoginErrorV2(reason: .invalidRequest, underlyingReason: "test invalid request")
        XCTAssertEqual(sut.errorDescription, "test invalid request")
        sut = LoginErrorV2(reason: .network, underlyingReason: "test network")
        XCTAssertEqual(sut.errorDescription, "test network")
        sut = LoginErrorV2(reason: .non200, underlyingReason: "test non 200")
        XCTAssertEqual(sut.errorDescription, "test non 200")
        sut = LoginErrorV2(reason: .userCancelled, underlyingReason: "test user cancelled")
        XCTAssertEqual(sut.errorDescription, "test user cancelled")
        sut = LoginErrorV2(reason: .serverError, underlyingReason: "test server error")
        XCTAssertEqual(sut.errorDescription, "test server error")
        sut = LoginErrorV2(reason: .accessDenied, underlyingReason: "test access denied")
        XCTAssertEqual(sut.errorDescription, "test access denied")
    }
}
