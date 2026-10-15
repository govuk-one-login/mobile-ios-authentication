@testable import Authentication
import Foundation
import Testing

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

        let configuration: LoginSessionConfiguration = await .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience)

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: configuration.authorizationEndpoint, session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: audience))))

        let sut: AppAuthSession = .makeWithMocks()

        await #expect(throws: LoginError(kind).self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
    }

    @Test
    @MainActor
    func test_loginFlow_invalidRedirectURL() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        // GIVEN a `OIDAuthorizationService` instance that never completes the session
        let service = MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.mock()

        let unique = UUID().uuidString
        let authorizationEndPoint = URL(string: "https://token.build.account.gov.uk/authorize?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub(authorizationEndPoint: authorizationEndPoint)
        let authorizationRequest = configuration.authorizationRequest
        let externalUserAgentSession = MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()
        service.stub(authorizationRequest: authorizationRequest, externalUserAgentSession: externalUserAgentSession)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted,
            object: externalUserAgentSession
        ).makeAsyncIterator()

        let task = Task {
            await #expect(throws: LoginError(.invalidRedirectURL).self) {
                try await sut.performLoginFlow(
                    configuration: configuration,
                    service: service)
            }
        }
        _ = await notificationAuthorizationFlowStarted.next()

        // THEN finalise will failExternalUserAgentFlowWithError
        try sut.finalise(redirectURL: authorizationRequest.redirectURL!)

        let error = await task.value
        #expect(error?.kind == .invalidRedirectURL)
    }

    @Test
    @MainActor
    func test_loginFlow_invalidRedirectURL_queryParams() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        // GIVEN a `OIDAuthorizationService` instance that never completes the session
        let service = MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.mock()

        let unique = UUID().uuidString
        let authorizationEndPoint = URL(string: "https://token.build.account.gov.uk/authorize?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub(authorizationEndPoint: authorizationEndPoint)
        let authorizationRequest = configuration.authorizationRequest
        let externalUserAgentSession = MockOIDExternalUserAgentSessionResumeFalseWithoutCallback()
        service.stub(authorizationRequest: authorizationRequest, externalUserAgentSession: externalUserAgentSession)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted,
            object: externalUserAgentSession
        ).makeAsyncIterator()

        let task = Task {
            await #expect(throws: LoginError(.invalidRedirectURL).self) {
                try await sut.performLoginFlow(
                    configuration: configuration,
                    service: service)
            }
        }
        _ = await notificationAuthorizationFlowStarted.next()

        // AND a call is made to finalise the "user agent session" with a redirect error
        let loginError: LoginErrorKind = .invalidRedirectURL
        let redirectURL: URL = authorizationRequest.stubRedirectURL(error: loginError.description)
        // THEN finalise will failExternalUserAgentFlowWithError
        try sut.finalise(redirectURL: redirectURL)

        let error = await task.value
        #expect(error?.kind == .invalidRedirectURL)
    }

    @MainActor
    @Test
    func test_loginFlow_tokenClientError() async throws {
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let service = MockOIDAuthorizationServiceStubsTokenRequest.mock()

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub()

        service.stub(endPoint: configuration.tokenEndpoint, error: OIDErrorOAuthToken.clientError)

        let sut: AppAuthSession = .makeWithMocks()

        await #expect(throws: LoginError(.tokenClientError)) {
            try await sut.performLoginFlow(
                configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience),
                service: service
            )
        }
    }
}
