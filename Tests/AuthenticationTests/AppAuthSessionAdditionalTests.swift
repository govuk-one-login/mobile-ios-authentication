import AppAuthCore
@testable import Authentication
import XCTest

extension AppAuthSessionTests {
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noAuthorizationResponse() throws {
        do {
            _ = try sut.handleAuthorizationResponseCreateTokenRequest(nil,
                                                                      error: nil,
                                                                      attestationHeaders: nil)
            XCTFail("Expected no authorization response error, got success")
        } catch LoginError.generic(let description) {
            XCTAssertEqual(description, "No Authorization Response")
        }
    }
    
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_addHeaders() throws {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        let authRequest = OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: "",
            scopes: nil,
            redirectURL: Foundation.URL(
                string: "https://www.google.com"
            )!,
            responseType: "code",
            additionalParameters: .init()
        )
        let authorizationResponse = MockAuthorizationResponse_AddingHeaders(
            request: authRequest,
            parameters: .init()
        )

        do {
            let tokenRequest = try sut.handleAuthorizationResponseCreateTokenRequest(
                authorizationResponse,
                error: nil,
                attestationHeaders: AttestationHeaders(
                    attestation: "test_value_1",
                    attestationPoP: "test_value_2"
                )
            )
            XCTAssertEqual(tokenRequest.additionalHeaders?["OAuth-Client-Attestation"], "test_value_1")
            XCTAssertEqual(tokenRequest.additionalHeaders?["OAuth-Client-Attestation-PoP"], "test_value_2")
        } catch {
            XCTFail("Expected no error, got error")
        }
    }
    
    @MainActor
    func test_handleAuthorizationResponseCreateTokenRequest_noTokenResponse() throws {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        let authRequest = OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: "",
            scopes: nil,
            redirectURL: Foundation.URL(
                string: "https://www.google.com"
            )!,
            responseType: "code",
            additionalParameters: .init()
        )
        let authorizationResponse = MockAuthorizationResponse_MissingTokenRequest(
            request: authRequest,
            parameters: .init()
        )
        
        do {
            _ = try sut.handleAuthorizationResponseCreateTokenRequest(authorizationResponse,
                                                                      error: nil,
                                                                      attestationHeaders: nil)
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
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        let tokenRequest = OIDTokenRequest(
            configuration: serviceConfiguration,
            grantType: "",
            authorizationCode: nil,
            redirectURL: nil,
            clientID: "",
            clientSecret: nil,
            scope: nil,
            refreshToken: nil,
            codeVerifier: nil,
            additionalParameters: nil,
            additionalHeaders: nil
        )
        let tokenResponse = MockTokenResponse_MissingProperty(
            request: tokenRequest,
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
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        let tokenRequest = OIDTokenRequest(
            configuration: serviceConfiguration,
            grantType: "",
            authorizationCode: nil,
            redirectURL: nil,
            clientID: "",
            clientSecret: nil,
            scope: nil,
            refreshToken: nil,
            codeVerifier: nil,
            additionalParameters: nil,
            additionalHeaders: nil
        )
        let tokenResponse = MockTokenResponse_FullyFormed(
            request: tokenRequest,
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
