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
            } catch LoginError.clientError {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected state mismatch error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 20)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com?code=\(UUID().uuidString)&state=\(UUID().uuidString)")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsUserCancelled() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_UserCancelled.self)
                XCTFail("Expected user cancelled error, got success")
            } catch LoginError.userCancelled {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected user cancelled error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)

        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsNetworkError() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_NetworkError.self)
                XCTFail("Expected network error, got success")
            } catch LoginError.network {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected network error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsNon200() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_Non200.self)
                XCTFail("Expected non 200 error, got success")
            } catch LoginError.non200 {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected non 200 error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsAuthorizationInvalidRequest() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_AuthorizationInvalidRequest.self)
                XCTFail("Expected authorization invalid request error, got success")
            } catch LoginError.invalidRequest {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsClientError() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_ClientError.self)
                XCTFail("Expected client error, got success")
            } catch LoginError.clientError {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_authService_rejectsTokenInvalidRequest() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock, service: MockOIDAuthState_TokenInvalidRequest.self)
                XCTFail("Expected token invalid request error, got success")
            } catch LoginError.invalidRequest {
                XCTAssertTrue(true)
            } catch {
                XCTFail("Expected token invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
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
