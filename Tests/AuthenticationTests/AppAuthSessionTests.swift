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
    
    func test_present_authService_callback_isCalled() async throws {
        let sessionConfig = LoginSessionConfiguration.mock
        await MainActor.run {
            sut.present(configuration: sessionConfig)
        }
        
        let _ = try await sut.finalise(callback: URL(string: "https://www.google.com?code=23234&state=\(config.state)")!)
        
        XCTAssertNotNil(sut.authorizationCode)
        XCTAssertNotNil(sut.stateReponse)
        XCTAssertNil(sut.error)
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!, responseType: .code, scopes: [.email, .offline_access, .phone, .openid], clientID: "1234", prefersEphemeralWebSession: true, redirectURI: "https://www.google.com", nonce: "1234", viewThroughRate: "1234", locale: .en)
}
