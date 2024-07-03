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
    
    func test_localAuthReturnsTouch() throws {
        sut.localAuthValue = .touch

        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .touch)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
    
    func test_localAuthReturnsPasscode() throws {
        sut.localAuthValue = .passcode

        sut.evaluateLocalAuth(navigationController: .init()) { type in
            XCTAssertTrue(type == .passcode)
        }
        XCTAssertTrue(sut.didCall_evaluateLocalAuth)
    }
}
