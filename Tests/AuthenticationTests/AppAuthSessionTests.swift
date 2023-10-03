@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    
    var sut: AppAuthSession!
    
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://www.google.com")!
        let window = UIWindow()
        
        sut = .init(window: window, service: MockTokenServicing as! TokenServicing)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension AppAuthSessionTests {
    func testFinaliseFunction() async {
        do {
            try await sut.finalise(callback: URL(string: "https://www.google.com")!)
        } catch {
            XCTAssertEqual(error as! LoginError, LoginError.inconsistentStateResponse)
        }
    }
}
