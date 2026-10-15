import AppAuthCore
@testable import Authentication
import Testing

struct AppAuthSessionAdditionalTests {
    @MainActor
    @Test
    func test_handleAuthorizationResponseCreateTokenRequest_noAuthorizationResponse() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        let error = await #expect(throws: LoginError(.generic)) {
            try await sut.handleAuthResponseCreateTokenRequest(
                nil,
                error: nil,
                tokenParameters: { nil },
                tokenHeaders: { nil }
            )
        }
        #expect(error?.reason == "No Authorization Response")
    }
    
    @MainActor
    @Test
    func test_handleAuthorizationResponseCreateTokenRequest_addHeaders() async throws {
        let authorizationResponse = MockAuthorizationResponse_AddingHeaders(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )

        let sut: AppAuthSession = .makeWithMocks()
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
        #expect(tokenRequest.additionalParameters?["token_parameter_1"] == "test_parameter_1")
        #expect(tokenRequest.additionalParameters?["token_parameter_2"] == "test_parameter_2")
        #expect(tokenRequest.additionalHeaders?["token_header_1"] == "test_header_1")
        #expect(tokenRequest.additionalHeaders?["token_header_2"] == "test_header_2")
    }
    
    @MainActor
    @Test
    func test_handleAuthorizationResponseCreateTokenRequest_noTokenResponse() async throws {
        let authorizationResponse = MockAuthorizationResponse_MissingTokenRequest(
            request: OIDAuthorizationRequest.mockAuthorizationRequest,
            parameters: .init()
        )

        let sut: AppAuthSession = .makeWithMocks()

        let error = await #expect(throws: LoginError(.generic)) {
            _ = try await sut.handleAuthResponseCreateTokenRequest(
                authorizationResponse,
                error: nil,
                tokenParameters: { nil },
                tokenHeaders: { nil }
            )
        }
        #expect(error?.reason == "Couldn't create Token Request")
    }
    
    @MainActor
    @Test
    func test_handleTokenResponse_noTokenResponse() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        let error = #expect(throws: LoginError(.generic)) {
            try sut.handleTokenResponse(
                nil,
                error: nil
            )
        }

        #expect(error?.reason == "No Token Response")
    }
    
    @MainActor
    @Test
    func test_handleTokenResponse_generateToken_error() throws {
        let tokenResponse = MockTokenResponse_MissingProperty(
            request: OIDTokenRequest.mockTokenRequest,
            parameters: .init()
        )
        
        let sut: AppAuthSession = .makeWithMocks()

        let error = #expect(throws: LoginError(.generic)) {
            _ = try sut.handleTokenResponse(
                tokenResponse,
                error: nil
            )
        }
        #expect(error?.reason == "Missing token property")
    }
    
    @MainActor
    @Test
    func test_handleTokenResponse_generateToken() throws {
        let tokenResponse = MockTokenResponse_FullyFormed(
            request: OIDTokenRequest.mockTokenRequest,
            parameters: .init()
        )
        
        let sut: AppAuthSession = .makeWithMocks()

        let tokens = try sut.handleTokenResponse(
                tokenResponse,
                error: nil
            )

        #expect(tokens.accessToken == "1234567890")
        #expect(tokens.tokenType == "mock token")
        #expect(tokens.refreshToken == "0987654321")
        #expect(tokens.idToken == "mock user")
        //#expect(tokens.expiryDate == tokenResponse.accessTokenExpirationDate!)
    }
}
