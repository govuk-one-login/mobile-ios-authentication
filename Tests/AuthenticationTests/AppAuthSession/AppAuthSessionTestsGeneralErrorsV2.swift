import AppAuthCore
@testable import Authentication
import XCTest

final class AppAuthSessionTestsV2: XCTestCase {
    var sut: AppAuthSessionV2!
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

extension AppAuthSessionTestsV2 {
    @MainActor
    func test_loginFlow_succeeds() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                let tokens = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_Success.self
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
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_userCancelled() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_UserCancelled.self
                )
                XCTFail("Expected user cancelled error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .userCancelled)
            } catch {
                XCTFail("Expected user cancelled error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_programCancelled() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_ProgramCancelled.self
                )
                XCTFail("Expected user cancelled error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .programCancelled)
            } catch {
                XCTFail("Expected user cancelled error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_networkError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_NetworkError.self
                )
                XCTFail("Expected network error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .network)
            } catch {
                XCTFail("Expected network error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_generalServerError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_GeneralServerError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .generalServerError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_safariOpenError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_SafariOpenError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .safariOpenError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 5)
    }
    
    // MARK: Finalise tests

    @MainActor
    func test_finalise_throwErrorWithNoAuthCode() throws {
        do {
            _ = try sut.finalise(redirectURL: redirectURL)
            XCTFail("Expected user agent session does not exist error, got success")
        } catch let error as LoginErrorV2 {
            XCTAssertEqual(error.reason, .generic(description: "User Agent Session does not exist"))
        } catch {
            XCTFail("Expected user agent session does not exist error, got \(error)")
        }
    }
    
    var redirectURL: URL {
        get throws {
            try XCTUnwrap(
                URL(string: "https://www.gov.uk")
            )
        }
    }
}
