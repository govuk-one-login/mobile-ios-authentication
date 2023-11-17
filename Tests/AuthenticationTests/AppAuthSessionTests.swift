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
            _ = try await sut.finalise(callback: URL(string: "https://www.google.com")!,
                                       endpoint: URL(string: "https://www.google.com/token")!)
            XCTFail("No AuthorizationCode was set should have failed at this point")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.inconsistentStateResponse)
        } catch {
            XCTFail("shouldn't catch generic error")
        }
    }
    
    func test_finaliseAuthService_rejectsIncorrectStateParameter() async throws {
        let sessionConfig = LoginSessionConfiguration.mock
        await sut.present(configuration: sessionConfig)
        
        let randomState = UUID().uuidString
        let code = UUID().uuidString
        
        do {
            _ = try await sut.finalise(callback: URL(string: "https://www.google.com?code=\(code)&state=\(randomState)")!,
                                       endpoint: URL(string: "https://www.google.com/token")!)
            XCTFail("Expected an error to be thrown")
        } catch LoginError.inconsistentStateResponse {
            XCTAssertNil(sut.authorizationCode)
            XCTAssertNil(sut.stateReponse)
        } catch {
            XCTFail("Unexpected error was thrown: \(error)")
        }
    }
    
    func test_present_authService_acquiresAuthCode() async throws {
        let sessionConfig = LoginSessionConfiguration.mock
        await sut.present(configuration: sessionConfig)
        
        let state = try XCTUnwrap(sut.state)
        let code = UUID().uuidString
        let callbackURL = try XCTUnwrap(URL(string: "https://www.google.com?code=\(code)&state=\(state)"))
        _ = try await sut.finalise(callback: callbackURL,
                                   endpoint: URL(string: "https://www.google.com/token")!)
        
        XCTAssertEqual(sut.authorizationCode, code)
        XCTAssertEqual(sut.stateReponse, state)
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                                tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                                responseType: .code,
                                                scopes: [.email, .offline_access, .phone, .openid],
                                                clientID: "1234",
                                                prefersEphemeralWebSession: true,
                                                redirectURI: "https://www.google.com",
                                                vectorsOfTrust: ["1234"],
                                                locale: .en)
}
