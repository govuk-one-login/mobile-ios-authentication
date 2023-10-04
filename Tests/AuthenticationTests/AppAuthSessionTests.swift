@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    
    var sut: AppAuthSession!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        let vc = UIViewController()
        window.rootViewController = vc
        
        sut = .init(window: window, service: MockTokenService())
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension AppAuthSessionTests {
    func test_finalise_throwErrorWithNoAuthCode() async {
        do {
            let _ = try await sut.finalise(callback: URL(string: "https://www.google.com")!)
            XCTFail("No AuthorizationCode was set should have failed at this point")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.inconsistentStateResponse)
        } catch {
            XCTFail("shouldn't catch generic error")
        }
    }
}
