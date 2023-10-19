@testable import Authentication
import XCTest

final class CustomAuthSessionTests: XCTestCase {

    var sut: CustomAuthSession!
    var config = LoginSessionConfiguration.mock
    
    override func setUpWithError() throws {
        let window = UIWindow()
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        sut = .init(window: window, service: MockTokenService())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

extension CustomAuthSessionTests {
    func test_finalise_throwErrorWithNoAuthCode() async {
        do {
            _ = try await sut.finalise(callback: URL(string: "https://www.google.com")!)
            XCTFail("No AuthorizationCode was set should have failed at this point")
        } catch let error as LoginError {
            XCTAssertEqual(error, .inconsistentStateResponse)
        } catch {
            XCTFail("Should not catch generic error")
        }
    }
    
    func test_finaliseAuthService_rejectsIncorrectStateParameter() async throws {
        sut.present(configuration: config)
        
        let randomState = UUID().uuidString
        let code = UUID().uuidString
        
        do {
            _ = try await sut.finalise(callback: URL(string: "https://www.google.com?code=\(code)&state=\(randomState)")!)
            XCTFail("Expected an error to be thrown")
        } catch let error as LoginError {
            XCTAssertEqual(error, .inconsistentStateResponse)
        } catch {
            XCTFail("Unexpected error was thrown: \(error)")
        }
    }
    
    func test_present_authService_acquiresAuthCode() async throws {
        let sessionConfig = LoginSessionConfiguration.mock
        sut.present(configuration: sessionConfig)
        
        let state = try XCTUnwrap(sut.state)
        let code = UUID().uuidString
        let callbackURL = try XCTUnwrap(URL(string: "https://www.google.com?code=\(code)&state=\(state)"))
        let tokenResponse = try await sut.finalise(callback: callbackURL)
        
        XCTAssertEqual(tokenResponse.accessToken, "1234")
    }
}
