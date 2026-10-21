@preconcurrency import AppAuthCore
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
        let authorizationResponse: OIDAuthorizationResponse = .mock(issuer: URL(string: "https://token.build.account.gov.uk")!)

        let sut: AppAuthSession = .makeWithMocks()
        let tokenRequest = try await sut.handleAuthResponseCreateTokenRequest(
            authorizationResponse,
            error: nil,
            tokenParameters: { [
                "token_parameter_1": "test_parameter_1",
                "token_parameter_2": "test_parameter_2"
            ] },
            tokenHeaders: { [
                "token_header_1": "test_header_1",
                "token_header_2": "test_header_2"
            ] }
        )
        #expect(tokenRequest.additionalParameters?["token_parameter_1"] == "test_parameter_1")
        #expect(tokenRequest.additionalParameters?["token_parameter_2"] == "test_parameter_2")
        #expect(tokenRequest.additionalHeaders?["token_header_1"] == "test_header_1")
        #expect(tokenRequest.additionalHeaders?["token_header_2"] == "test_header_2")
    }
    
    @MainActor
    @Test
    func test_handleAuthorizationResponseCreateTokenRequest_noTokenResponse() async throws {
        let authorizationResponse: OIDAuthorizationResponse = .mock(tokenExchangeRequest: nil)

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
    func test_handleTokenResponse_noTokenResponse() throws {
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
        let tokenResponse: OIDTokenResponse = .mock(
            accessToken: nil
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
        let accessToken = "1234567890"
        let tokenType = "mock token"
        let refreshToken = "0987654321"
        let idToken = "mock user"
        let accessTokenExpirationDate = Date()

        let tokenResponse: OIDTokenResponse = .mock(
            accessToken: accessToken,
            tokenType: tokenType,
            refreshToken: refreshToken,
            idToken: idToken,
            accessTokenExpirationDate: accessTokenExpirationDate
        )
        
        let sut: AppAuthSession = .makeWithMocks()

        let tokens = try sut.handleTokenResponse(
                tokenResponse,
                error: nil
            )

        #expect(tokens.accessToken == tokenResponse.accessToken)
        #expect(tokens.tokenType == tokenResponse.tokenType)
        #expect(tokens.refreshToken == tokenResponse.refreshToken)
        #expect(tokens.idToken == tokenResponse.idToken)
        #expect(tokens.expiryDate == tokenResponse.accessTokenExpirationDate)
    }
}
