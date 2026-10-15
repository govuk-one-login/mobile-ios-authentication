@testable import Authentication
import Testing
import XCTest

extension AppAuthSessionXCTests {
        
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

struct AppAuthSessionOAuthTokenErrorDomainTests {

    @MainActor
    @Test(arguments:
            [(error: OIDError.invalidRequest, kind: LoginErrorKind.tokenInvalidRequest),
             (error: OIDError.unauthorizedClient, kind: LoginErrorKind.tokenUnauthorizedClient),
             (error: OIDError.invalidScope, kind: LoginErrorKind.tokenInvalidScope),
             (error: OIDError.invalidClient, kind: LoginErrorKind.tokenInvalidClient),
             (error: OIDError.invalidGrant, kind: LoginErrorKind.tokenInvalidGrant),
             (error: OIDError.unsupportedGrantType, kind: LoginErrorKind.tokenUnsupportedGrantType),
             (error: OIDError.unknown, kind: LoginErrorKind.tokenUnknownError)]
    )
    func assert_loginFlow(error: OIDError, map kind: LoginErrorKind) async throws {
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        try MockTokenURLProtocol.token(endPoint: endPoint, stub: error, statusCode: 400)

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: endPoint, session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: audience))))

        let sut: AppAuthSession = .makeWithMocks()

        await #expect(throws: LoginError(kind).self) {
            try await sut.performLoginFlow(
                configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience),
                service: service)
        }
    }
}
