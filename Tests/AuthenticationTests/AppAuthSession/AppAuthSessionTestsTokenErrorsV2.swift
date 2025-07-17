import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTestsV2 {
    private var redirectURL: URL {
        get throws {
            try XCTUnwrap(
                URL(string: "https://www.gov.uk")
            )
        }
    }

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
        
        try sut.finalise(redirectURL: redirectURL)

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
        
        try sut.finalise(redirectURL: redirectURL)

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
        
        try sut.finalise(redirectURL: redirectURL)

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
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenInvalidGrant)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)

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
        
        try sut.finalise(redirectURL: redirectURL)

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
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .tokenUnknownError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)
    }

    @MainActor
    func test_loginFlow_invalidRedirectURL() throws {
        // GIVEN I am logging in
        let exp = expectation(description: "wait for login to be displayed")
        let exp2 = expectation(description: "expect flow to be cancelled")
        Task {
            exp.fulfill()
            _ = try await sut.performLoginFlow(
                configuration: .mock(),
                service: MockOIDAuthorizationService_Success.self
            )
            exp2.fulfill()
        }
        wait(for: [exp], timeout: 4)
        waitForTruth(self.sut.isActive, timeout: 4)

        // WHEN I receive an invalid redirect URL
        do {
            try sut.finalise(redirectURL: redirectURL)
        } catch let error as LoginErrorV2 {
            // THEN AN error is thrown
            XCTAssertEqual(error.reason, .invalidRedirectURL)
            // AND the session is cleared
            XCTAssertTrue(sut.isActive)
        }

        // AND the waiting task is cancelled
        wait(for: [exp2], timeout: 4)
    }
}
