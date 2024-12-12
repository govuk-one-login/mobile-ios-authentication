import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTests {
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noAuthorizationResponse() throws {
        do {
            _ = try sut.handleAuthorizationResponseCreateTokenRequest(
                nil,
                error: nil
            )
            XCTFail("Expected no authorization response error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertEqual(description, "No Authorization Response")
        }
    }
    
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noTokenResponse() throws {
        let authorizationResponse = MockAuthorizationResponse_MissingTokenRequest(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )
        
        do {
            _ = try sut.handleAuthorizationResponseCreateTokenRequest(
                authorizationResponse,
                error: nil
            )
            XCTFail("Expected no token request error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertEqual(description, "Couldn't create Token Request")
        }
    }
    
    @MainActor
    func test_handleTokenResponse_noTokenResponse() throws {
        do {
            _ = try sut.handleTokenResponse(
                nil,
                error: nil
            )
            XCTFail("Expected no token response error, got success")
        } catch LoginError.generic(description: let description) {
            XCTAssertEqual(description, "No Token Response")
        }
    }
    
    @MainActor
    func test_handleTokenResponse_generateToken_error() throws {
        let tokenResponse = MockTokenResponse_MissingProperty(
            request: OIDTokenRequest.mockTokenRequest,
            parameters: .init()
        )
        
        do {
            _ = try sut.handleTokenResponse(
                tokenResponse,
                error: nil
            )
            XCTFail("Expected no token response error, got success")
        } catch LoginError.generic(description: let description) {
            XCTAssertEqual(description, "Missing token property")
        }
    }
    
    @MainActor
    func test_handleTokenResponse_generateToken() throws {
        let tokenResponse = MockTokenResponse_FullyFormed(
            request: OIDTokenRequest.mockTokenRequest,
            parameters: .init()
        )
        
        do {
            let tokens = try sut.handleTokenResponse(
                tokenResponse,
                error: nil
            )
            XCTAssertEqual(tokens.accessToken, "1234567890")
            XCTAssertEqual(tokens.tokenType, "mock token")
            XCTAssertEqual(tokens.refreshToken, "0987654321")
            XCTAssertEqual(tokens.idToken, "mock user")
            XCTAssertNotNil(tokens.expiryDate)
        } catch {
            XCTFail("Expected no token response error, got success")
        }
    }
}
