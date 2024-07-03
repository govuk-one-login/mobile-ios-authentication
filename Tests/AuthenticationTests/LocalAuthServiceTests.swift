@testable import Authentication
import XCTest

final class LocalAuthServiceTests: XCTestCase {
    var sut = MockLocalAuthService()
}

extension LocalAuthServiceTests {
    func test_localAuthReturnsNone() throws {
        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .none)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
    
    func test_localAuthReturnsFace() throws {
        sut.localAuthValue = .face
        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .face)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
    
    func test_localAuthReturnsFinger() throws {
        sut.localAuthValue = .finger

        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .finger)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
    
    func test_localAuthReturnsPass() throws {
        sut.localAuthValue = .pass

        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .pass)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
}
