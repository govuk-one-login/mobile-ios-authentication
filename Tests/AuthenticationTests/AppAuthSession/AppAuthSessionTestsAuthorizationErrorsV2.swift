import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTestsV2 {
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationInvalidRequest)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationUnauthorizedClient)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationAccessDenied)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationUnsupportedResponseType)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationInvalidScope)
            } catch {
                XCTFail("Expected authorization invalid request error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationServerError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationTemporarilyUnavailable)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
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
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationClientError)
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
    func test_loginFlow_present_authorizationUnknownError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_AuthorizationUnknownError.self
                )
                XCTFail("Expected client error, got success")
            } catch let error as LoginErrorV2 {
                XCTAssertEqual(error.reason, .authorizationUnknownError)
            } catch {
                XCTFail("Expected client error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 5)
        
        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        
        wait(for: [exp], timeout: 5)
    }
    
//    @MainActor
//    func test_loginFlow_incorrectStateParameter() throws {
//        let exp = expectation(description: "Wait for token response")
//
//        Task {
//            do {
//                _ = try await sut.performLoginFlow(configuration: .mock())
//                XCTFail("Expected client error, got success")
//            } catch let error as LoginErrorV2 {
//                XCTAssertEqual(error.reason, .authorizationClientError)
//            } catch {
//                XCTFail("Expected client error, got \(error)")
//            }
//            
//            exp.fulfill()
//        }
//        
//        waitForTruth(self.sut.isActive, timeout: 5)
//        
//        try sut.finalise(redirectURL: URL(string: "https://www.google.com?code=\(UUID().uuidString)&state=\(UUID().uuidString)")!)
//        
//        wait(for: [exp], timeout: 5)
//    }
//    
//    @MainActor
//    func test_loginFlow_tokenInvalidRequestError() throws {
//        let exp = expectation(description: "Wait for token response")
//        Task {
//            do {
//                _ = try await sut.performLoginFlow(
//                    configuration: .mock(),
//                    service: MockOIDAuthorizationService_TokenInvalidRequest.self
//                )
//                XCTFail("Expected token invalid request error, got success")
//            } catch let error as LoginErrorV2 {
//                XCTAssertEqual(error.reason, .tokenInvalidRequest)
//            } catch {
//                XCTFail("Expected token invalid request error, got \(error)")
//            }
//            
//            exp.fulfill()
//        }
//        
//        waitForTruth(self.sut.isActive, timeout: 5)
//        
//        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
//        
//        wait(for: [exp], timeout: 5)
//    }
//    
//    @MainActor
//    func test_loginFlow_present_rejectsAccessDenied() throws {
//        let exp = expectation(description: "Wait for token response")
//        Task {
//            do {
//                _ = try await sut.performLoginFlow(
//                    configuration: .mock(),
//                    service: MockOIDAuthorizationService_AuthorizationAccessDeniedError.self
//                )
//                XCTFail("Expected server error, got success")
//            } catch let error as LoginErrorV2 {
//                XCTAssertEqual(error.reason, .authorizationAccessDenied)
//            } catch {
//                XCTFail("Expected server error, got \(error)")
//            }
//            
//            exp.fulfill()
//        }
//        
//        waitForTruth(self.sut.isActive, timeout: 5)
//        
//        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
//        
//        wait(for: [exp], timeout: 5)
//    }
//    
//    @MainActor
//    func test_loginFlow_perform_clientError() throws {
//        let exp = expectation(description: "Wait for token response")
//        Task {
//            do {
//                _ = try await sut.performLoginFlow(
//                    configuration: .mock(),
//                    service: MockOIDAuthorizationService_Perform_ClientError.self
//                )
//                XCTFail("Expected client error, got success")
//            } catch let error as LoginErrorV2 {
//                XCTAssertEqual(error.reason, .tokenClientError)
//            } catch {
//                XCTFail("Expected client error, got \(error)")
//            }
//            
//            exp.fulfill()
//        }
//        
//        waitForTruth(self.sut.isActive, timeout: 5)
//        
//        try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
//        
//        wait(for: [exp], timeout: 5)
//    }
//    
//
//    
//    // MARK: Finalise tests
//    
//    @MainActor
//    func test_finalise_throwErrorWithNoAuthCode() throws {
//        do {
//            _ = try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
//            XCTFail("Expected user agent session does not exist error, got success")
//        } catch let error as LoginErrorV2 {
//            XCTAssertEqual(error.reason, .generic(description: ""))
//        } catch {
//            XCTFail("Expected user agent session does not exist error, got \(error)")
//        }
//    }
}
