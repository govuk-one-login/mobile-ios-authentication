@testable import Authentication
import XCTest

extension AppAuthSessionTests {
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenInvalidRequest)
            } catch {
                XCTFail("Expected token invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenUnauthorizedClient)
            } catch {
                XCTFail("Expected token invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenInvalidScope)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenInvalidClient)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_tokenInvalidGrantError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenInvalidGrantError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenInvalidGrant)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenUnsupportedGrantType)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
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
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenClientError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_tokenUnknownError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_TokenUnknownError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .tokenUnknownError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_invalidRedirectURL() throws {
        // GIVEN I am logging in
        let exp = expectation(description: "wait for login to be displayed")
        Task {
            exp.fulfill()
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_InvalidURL.self
                )
                XCTFail("Expected Login Error to be thrown")
            } catch let error as LoginError {
                // THEN AN error is thrown
                XCTAssertEqual(error.kind, .invalidRedirectURL)
                // AND the session is cleared
                XCTAssertTrue(sut.isActive)
            }
        }
        wait(for: [exp], timeout: 10)
        waitForTruth(self.sut.isActive, timeout: 10)
        
        // WHEN I receive an invalid redirect URL
        try sut.finalise(redirectURL: redirectURL)
    }
    
    @MainActor
    func test_loginFlow_invalidRedirectURL_queryParams() throws {
        // GIVEN I am logging in
        let exp = expectation(description: "wait for login to be displayed")
        Task {
            exp.fulfill()
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_InvalidURL.self
                )
                XCTFail("Expected Login Error to be thrown")
            } catch let error as LoginError {
                // THEN AN error is thrown
                XCTAssertEqual(error.kind, .invalidRedirectURL)
                XCTAssertEqual(error.reason, "unknown: server_error")
            }
        }
        wait(for: [exp], timeout: 10)
        waitForTruth(self.sut.isActive, timeout: 10)
        
        // WHEN I receive an invalid redirect URL
        try sut.finalise(redirectURL: try XCTUnwrap(URL(string: "https://www.gov.uk?error=unknown&error_description=server_error")))
    }
}
