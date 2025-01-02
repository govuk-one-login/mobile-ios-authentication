import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTests {
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noAuthorizationResponse() async throws {
        do {
            _ = try await sut.handleAuthResponseCreateTokenRequest(
                nil,
                error: nil,
                tokenParameters: {nil},
                tokenHeaders: {nil}
            )
            XCTFail("Expected no authorization response error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertEqual(description, "No Authorization Response")
        }
    }
    
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_addHeaders() async throws {
        let authorizationResponse = MockAuthorizationResponse_AddingHeaders(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )

        do {
            let tokenRequest = try await sut.handleAuthResponseCreateTokenRequest(
                authorizationResponse,
                error: nil,
                tokenParameters: {[
                    "token_parameter_1": "test_parameter_1",
                    "token_parameter_2": "test_parameter_2"
                ]},
                tokenHeaders: {[
                    "token_header_1": "test_header_1",
                    "token_header_2": "test_header_2"
                ]}
            )
            XCTAssertEqual(tokenRequest.additionalParameters?["token_parameter_1"], "test_parameter_1")
            XCTAssertEqual(tokenRequest.additionalParameters?["token_parameter_2"], "test_parameter_2")
            XCTAssertEqual(tokenRequest.additionalHeaders?["token_header_1"], "test_header_1")
            XCTAssertEqual(tokenRequest.additionalHeaders?["token_header_2"], "test_header_2")
        } catch {
            XCTFail("Expected no error, got error")
        }
    }
    
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noTokenResponse() async throws {
        let authorizationResponse = MockAuthorizationResponse_MissingTokenRequest(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )
        
        do {
            _ = try await sut.handleAuthResponseCreateTokenRequest(
                authorizationResponse,
                error: nil,
                tokenParameters: {nil},
                tokenHeaders: {nil}
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
