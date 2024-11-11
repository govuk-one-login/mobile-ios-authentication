import AppAuthCore
@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    var sut: AppAuthSession!
    var config = LoginSessionConfiguration.mock
    
    @MainActor
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
    // MARK: Present tests

    @MainActor
    func test_authService_rejectsIncorrectStateParameter() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock)
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .clientError)
            } catch {
                XCTFail("Expected client error, got \(error)")
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
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_UserCancelled.self
                )
                XCTFail("Expected user cancelled error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .userCancelled)
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
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_NetworkError.self
                )
                XCTFail("Expected network error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .network)
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
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_Non200.self
                )
                XCTFail("Expected non 200 error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .non200)
            } catch {
                XCTFail("Expected non 200 error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 4)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 4)
    }
    
    @MainActor
    func test_authService_rejectsAuthorizationInvalidRequest() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_AuthorizationInvalidRequest.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .invalidRequest)
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
    func test_authService_rejectsTokenInvalidRequest() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_TokenInvalidRequest.self
                )
                XCTFail("Expected token invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .invalidRequest)
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
    func test_authService_rejectsClientError() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_ClientError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .clientError)
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
    func test_authService_rejectsServerError() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_ServerError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .serverError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: Perform tests
    
    @MainActor
    func test_authService_perform_clientError() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_Perform_ClientError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error, .clientError)
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
    func test_authService_perform() throws {
        let exp = expectation(description: "Wait for token response")
        Task {
            do {
                let tokens = try await sut.performLoginFlow(
                    configuration: .mock,
                    service: MockOIDAuthorizationService_Perform_Flow.self
                )
                XCTAssertEqual(tokens.accessToken, "1234567890")
                XCTAssertEqual(tokens.tokenType, "mock token")
                XCTAssertEqual(tokens.refreshToken, "0987654321")
                XCTAssertEqual(tokens.idToken, "mock user")
                XCTAssertNotNil(tokens.expiryDate)
            } catch {
                XCTFail("Expected tokens, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: Finalise tests
    
    @MainActor
    func test_finalise_throwErrorWithNoAuthCode() throws {
        do {
            _ = try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
            XCTFail("Expected user agent session does not exist error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "User Agent Session does not exist")
        } catch {
            XCTFail("Expected user agent session does not exist error, got \(error)")
        }
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(
        authorizationEndpoint: URL(string: "https://www.google.com")!,
        tokenEndpoint: URL(string: "https://www.google.com/token")!,
        clientID: "1234",
        redirectURI: "https://www.google.com"
    )
}
