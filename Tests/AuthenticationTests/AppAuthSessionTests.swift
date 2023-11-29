@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    var sut: AppAuthSession!
    var config = LoginSessionConfiguration.mock
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        sut = .init(window: window)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension AppAuthSessionTests {
    @MainActor 
    func test_finaliseAuthService_rejectsIncorrectStateParameter() async throws {
        sut.present(configuration: .mock)
        
        let code = UUID().uuidString
        let randomState = UUID().uuidString
        do {
            let _ = try await sut.finalise(redirectURL: URL(string: "https://www.google.com?code=\(code)&state=\(randomState)")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description.starts(with: "State mismatch"))
        }
    }
    
    func test_finalise_throwErrorWithNoAuthCode() async throws {
        do {
            let _ = try await sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "User Agent Session does not exist")
        }
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                                tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                                clientID: "1234",
                                                redirectURI: "https://www.google.com")
}
