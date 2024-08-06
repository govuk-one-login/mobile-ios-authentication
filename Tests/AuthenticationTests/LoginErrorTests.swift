@testable import Authentication
import XCTest

final class LoginErrorTests: XCTestCase {
    var sut: LoginError!
}

extension LoginErrorTests {
    func test_localizedDescription() throws {
        sut = .clientError
        XCTAssertEqual(sut.localizedDescription, "client error")
        sut = .generic(description: "generic error")
        XCTAssertEqual(sut.localizedDescription, "generic error")
        sut = .invalidRequest
        XCTAssertEqual(sut.localizedDescription, "invalid request")
        sut = .network
        XCTAssertEqual(sut.localizedDescription, "network")
        sut = .non200
        XCTAssertEqual(sut.localizedDescription, "non 200")
        sut = .userCancelled
        XCTAssertEqual(sut.localizedDescription, "user cancelled")
        sut = .serverError
        XCTAssertEqual(sut.localizedDescription, "server error")
    }
}
