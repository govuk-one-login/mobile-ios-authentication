import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTestsV2 {
    @MainActor
    func test_loginFlow_tokenInvalidRequestError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenInvalidRequestError.self
                )
                XCTFail("Expected token invalid request error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenInvalidRequest)
            } catch {
                XCTFail("Expected token invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_tokenUnauthorizedClientError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenUnauthorizedClientError.self
                )
                XCTFail("Expected token invalid request error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenUnauthorizedClient)
            } catch {
                XCTFail("Expected token invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_tokenInvalidScopeError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenInvalidScopeError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenInvalidScope)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_tokenInvalidClientError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenInvalidClientError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenInvalidClient)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_tokenUnsupportedGrantTypeError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenUnsupportedGrantTypeError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenUnsupportedGrantType)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    @MainActor
    func test_loginFlow_tokenClientError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenClientError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenClientError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
    // MARK: Finalise tests
    
    @MainActor
    func test_finalise_throwErrorWithNoAuthCode() throws {
        do {
            _ = try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
            XCTFail("Expected user agent session does not exist error, got success")
        } catch let error as LoginErrorV2 {
            XCTAssertEqual(error.reason, .generic(description: "User Agent Session does not exist"))
        } catch {
            XCTFail("Expected user agent session does not exist error, got \(error)")
        }
    }
}
