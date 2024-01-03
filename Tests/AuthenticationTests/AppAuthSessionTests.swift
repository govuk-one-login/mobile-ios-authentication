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
    func test_finalise_throwErrorWithNoAuthCode() async throws {
        do {
            _ = try await sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
            XCTFail("Expected user agent session does not exist error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "User Agent Session does not exist")
        } catch {
            XCTFail("Expected user agent session does not exist error, got \(error)")
        }
    }
    
    @MainActor
    func test_authService_rejectsIncorrectStateParameter() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock)
                XCTFail("Expected state mismatch error, got success")
            } catch LoginError.generic(let description) {
                XCTAssertTrue(description.starts(with: "State mismatch"))
            } catch {
                XCTFail("Expected state mismatch error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com?code=\(UUID().uuidString)&state=\(UUID().uuidString)")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsWhenNoAuthState() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_NothingReturned.self)
                XCTFail("Expected no authstate error, got success")
            } catch LoginError.generic(let description) {
                XCTAssertTrue(description == "No authState")
            } catch {
                XCTFail("Expected no authstate error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsWhenAuthStateMissingToken() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_MissingAuthStateToken.self)
                XCTFail("Expected authstate token response error, got success")
            } catch LoginError.generic(let description) {
                XCTAssertTrue(description == "Missing authState Token Response")
            } catch {
                XCTFail("Expected authstate token response error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsWhenAuthStateMissingProperty() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_MissingAuthStateProperty.self)
                XCTFail("Expected missing authstate property error, got success")
            } catch LoginError.generic(let description) {
                XCTAssertTrue(description == "Missing authState property")
            } catch {
                XCTFail("Expected missing authstate property error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                                tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                                clientID: "1234",
                                                redirectURI: "https://www.google.com")
}
