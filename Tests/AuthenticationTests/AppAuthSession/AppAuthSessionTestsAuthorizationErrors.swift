import AppAuthCore
@testable import Authentication
import Testing
import XCTest

struct AppAuthSessionTests {

    @MainActor
    @Test
    func test_loginFlow_authorizationAccessDeniedError() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        // GIVEN a `OIDAuthorizationService` instance that never completes the session
        let service = MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting.mock()

        let unique = UUID().uuidString
        let authorizationEndPoint = URL(string: "https://token.build.account.gov.uk/authorize?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub(authorizationEndPoint: authorizationEndPoint)
        let authorizationRequest = configuration.authorizationRequest
        let userAgent = MockOIDExternalUserAgent()
        service.stub(authorizationRequest: authorizationRequest, externalUserAgent: userAgent)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDExternalUserAgent.authorizationFlowStarted,
            object: userAgent
        ).makeAsyncIterator()

        let task = Task {
            await #expect(throws: LoginError(.authorizationAccessDenied).self) {
                _ = try await sut.performLoginFlow(
                    configuration: configuration,
                    service: service)
            }
        }
        _ = await notificationAuthorizationFlowStarted.next()

        // AND a call is made to finalise the "user agent session" with a redirect error
        let anyError: OIDError = .accessDenied
        let redirectURL: URL = authorizationRequest.stubRedirectURL(error: anyError)
        // THEN finalise will failExternalUserAgentFlowWithError
        try sut.finalise(redirectURL: redirectURL)

        let error = await task.value
        #expect(error?.kind == .authorizationAccessDenied)
    }

    @MainActor
    @Test(arguments:
            [(error: OIDErrorOAuth.invalidRequest, kind: LoginErrorKind.authorizationInvalidRequest),
             (error: OIDErrorOAuth.unauthorizedClient, kind: LoginErrorKind.authorizationUnauthorizedClient),
             (error: OIDErrorOAuth.unsupportedResponseType, kind: LoginErrorKind.authorizationUnsupportedResponseType),
             (error: OIDErrorOAuth.invalidScope, kind: LoginErrorKind.authorizationInvalidScope),
             (error: OIDErrorOAuth.serverError, kind: LoginErrorKind.authorizationServerError),
             (error: OIDErrorOAuth.temporarilyUnavailable, kind: LoginErrorKind.authorizationTemporarilyUnavailable),
             (error: OIDErrorOAuth.clientError, kind: LoginErrorKind.authorizationClientError),
             (error: OIDErrorOAuth.other, kind: LoginErrorKind.authorizationUnknownError)]
    )
    func assert_loginFlow(error: Error, map kind: LoginErrorKind) async throws {
        let sut: AppAuthSession = .makeWithMocks()

        // GIVEN a `OIDAuthorizationService` instance that never completes the session
        let service = MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.mock()

        let unique = UUID().uuidString
        let authorizationEndPoint = URL(string: "https://token.build.account.gov.uk/authorize?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub(authorizationEndPoint: authorizationEndPoint)
        let authorizationRequest = configuration.authorizationRequest
        let externalUserAgentSession = MockOIDExternalUserAgentSessionResumeError(error: error)
        service.stub(authorizationRequest: authorizationRequest, externalUserAgentSession: externalUserAgentSession)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDAuthorizationServiceExternalUserAgentSessionResumeFalse.authorizationFlowStarted,
            object: externalUserAgentSession
        ).makeAsyncIterator()

        let task = Task {
            await #expect(throws: LoginError(kind).self) {
                try await sut.performLoginFlow(
                    configuration: configuration,
                    service: service)
            }
        }
        _ = await notificationAuthorizationFlowStarted.next()

        // THEN finalise will failExternalUserAgentFlowWithError
        try sut.finalise(redirectURL: authorizationRequest.redirectURL!)

        let error = await task.value
        #expect(error?.kind == kind)
    }
}
