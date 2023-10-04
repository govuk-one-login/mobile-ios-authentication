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
    
    func test_finalise_returnsToken() async throws {
        sut.handlePresentCallback(authorizationCode: "1234", state: "123", error: nil)
        let token = try await sut.finalise(callback: URL(string: "https://www.google.com")!)
        XCTAssertEqual(token.accessToken, "1234")
    }
    
    func test_present() {
        let url = URL(string: "https://www.google.com")!
        
        let config = LoginSessionConfiguration(authorizationEndpoint: url, responseType: .code, scopes: [.email], clientID: "1234", prefersEphemeralWebSession: true, redirectURI: "https://www.google.com", nonce: "1234", viewThroughRate: "1", locale: .en)
        
        sut.present(configuration: config)
    }
    
    func test_finalise_throwErrorWhenWrongState() async throws {
        let url = URL(string: "https://www.google.com")!
        
        let config = LoginSessionConfiguration(authorizationEndpoint: url, responseType: .code, scopes: [.email], clientID: "1234", prefersEphemeralWebSession: true, redirectURI: "https://www.google.com", nonce: "1234", viewThroughRate: "1", locale: .en)
        
        sut.present(configuration: config)
        Task {
            sut.handlePresentCallback(authorizationCode: "1234", state: config.state, error: nil)
        }
        
        
        do {
            let _ = try await sut.finalise(callback: url)
            XCTFail("Failed as we should have thrown error by now")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.inconsistentStateResponse)
        } catch {
            XCTFail("shouldn't catch generic error")
        }
    }
}
