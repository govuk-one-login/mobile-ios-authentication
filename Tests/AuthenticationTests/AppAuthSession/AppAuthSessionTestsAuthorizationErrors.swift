@testable import Authentication
import XCTest

extension AppAuthSessionTests {
    @MainActor
    func test_loginFlow_authorizationInvalidRequestError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationInvalidRequestError.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationInvalidRequest)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationUnauthorizedClientError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationUnauthorizedClientError.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationUnauthorizedClient)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationAccessDeniedError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationAccessDeniedError.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationAccessDenied)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationUnsupportedResponseTypeError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationUnsupportedResponseTypeError.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationUnsupportedResponseType)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationInvalidScopeError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationInvalidScopeError.self
                )
                XCTFail("Expected authorization invalid request error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationInvalidScope)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationServerError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationServerError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationServerError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_authorizationTemporarilyUnavailableError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationTemporarilyUnavailableError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationTemporarilyUnavailable)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_present_authorizationClientError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationClientError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationClientError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_present_authorizationUnknownError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationUnknownError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .authorizationUnknownError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 10)
    }
}
