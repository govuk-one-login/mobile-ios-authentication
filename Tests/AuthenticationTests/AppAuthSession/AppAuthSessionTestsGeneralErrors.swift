// swiftlint:disable file_length
@preconcurrency import AppAuthCore
@testable import Authentication
import Testing
import UIKit

// swiftlint:disable:next type_body_length
struct AppAuthSessionTestsGeneralErrors {
    @MainActor
    @Test
    func test_loginFlow_succeeds() async throws {
        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let accessToken = "1234567890"
        let tokenType = "mock token"
        let refreshToken = "0987654321"
        let expiryDate = Date()
        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint,
                                       claim: Claim.make(
                                        accessToken: accessToken,
                                        tokenType: tokenType,
                                        refreshToken: refreshToken,
                                        expiryDate: expiryDate
                                       ),
                                       stub: claims)
        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()

        let tokens = try await sut.performLoginFlow(
            configuration: configuration,
            service: service
        )

        #expect(tokens.accessToken == accessToken)
        #expect(tokens.tokenType == tokenType)
        #expect(tokens.refreshToken == refreshToken)
        #expect(tokens.idToken != nil)
        #expect(tokens.expiryDate > expiryDate)
    }

    @MainActor
    @Test
    func test_loginFlow_userCancelled() async {
        let sut: AppAuthSession = .makeWithMocks()

        let service = MockOIDAuthorizationServiceExternalUserAgentPending.mock()

        let unique = UUID().uuidString
        let authorizationEndPoint = URL(string: "https://token.build.account.gov.uk/authorize?u=\(unique)")!

        let configuration = await LoginSessionConfiguration.stub(authorizationEndPoint: authorizationEndPoint)
        let authorizationRequest = configuration.authorizationRequest
        let userAgent = MockOIDExternalUserAgentSessionCancel(error: OIDError.error(code: .userCanceledAuthorizationFlow))
        service.stub(authorizationRequest: authorizationRequest, externalUserAgentSession: userAgent)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted,
            object: userAgent
        ).makeAsyncIterator()

        let task = Task {
            await #expect(throws: LoginError(.userCancelled).self) {
                try await sut.performLoginFlow(
                    configuration: configuration,
                    service: service)
            }
        }

        _ = await notificationAuthorizationFlowStarted.next()

        await userAgent.cancel()

        let error = await task.value
        #expect(error?.kind == .userCancelled)
    }

    @MainActor
    @Test
    func test_loginFlow_generalServerError() async throws {
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer, expiresAt: Date.distantPast)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims, statusCode: 400)

        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()

        await #expect(throws: LoginError(.generalServerError).self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
    }

    // MARK: A suite of tests on ID token verification
    // A Suite of tests that assert the validity of an ID token in the format expected to be issued by STS.
    
    @MainActor
    @Test
    func test_loginFlow_succeeds_validation() async throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.build.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request matches the audience
        //  ASSERT that no (validation) error occured
        
        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()
        
        await #expect(throws: Never.self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
    }
    
    @MainActor
    @Test
    func test_loginFlow_fails_validation_issuer_mismatch() async throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.build.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request DOES NOT match the issuer
        //  AND the request matches the audience
        //  ASSERT that a login error occured for the issuer mismatch

        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let mismatchedIssuer = "https://invalid.gov.uk"
        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: mismatchedIssuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: mismatchedIssuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()
        // When
        let caughtError = await #expect(throws: LoginError(.generic).self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
        
        let originalError = try #require(caughtError?.originalError as? NSError)
        #expect(originalError == OIDError.issuerMismatch as NSError)
    }

    @MainActor
    @Test
    func test_loginFlow_fails_validation_audience_mismatch() async throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.build.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request DOES NOT match the audience
        //  ASSERT that a login error occured for the audience mismatch

        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let invalidAudience = "invalid aud"
        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: invalidAudience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()
        // When
        let caughtError = await #expect(throws: LoginError.self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                    service: service)
        }
        
        let originalError = try #require(caughtError?.originalError as? NSError)
        #expect(originalError == OIDError.audienceMismatch as NSError)
    }
    
    @MainActor
    @Test
    func test_loginFlow_fails_validation_token_expired() async throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.build.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  AND the token has long EXPIRED
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request matches the audience
        //  ASSERT that a login error occured for the expired id token

        // Given an EXPIRED token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"
      
        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer, expiresAt: Date.distantPast)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )
        
        let sut: AppAuthSession = .makeWithMocks()

        // When
        let caughtError = await #expect(throws: LoginError.self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
        
        let originalError = try #require(caughtError?.originalError as? NSError)
        #expect(originalError == OIDError.idTokenExpired as NSError)
    }

    @MainActor
    @Test
    func test_loginFlow_fails_due_to_networkerror() async throws {
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.build.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.build.account.gov.uk/token?u=\(unique)")!

        // Given a network error (e.g. networkConnectionLost)
        try MockTokenURLProtocol.error(endPoint: endPoint, error: URLError(.networkConnectionLost))

        let configuration: LoginSessionConfiguration = await .stub(
            tokenEndPoint: endPoint,
            issuer: URL(string: issuer),
            audience: audience
        )

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        let userAgentSession: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow = .mockResumeExternalUserAgentFlowWith(
            authorizationResponse: .mock(
                tokenExchangeRequest: .mock(
                    endPoint: endPoint,
                    issuer: URL(string: issuer),
                    audience: audience
                )
            )
        )
        service.stub(endPoint: configuration.authorizationEndpoint,
                     session: userAgentSession
        )

        let sut: AppAuthSession = .makeWithMocks()

        await #expect(throws: LoginError(.network).self) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }
    }

    // MARK: end of suite

    @MainActor
    @Test
    func test_loginFlow_safariOpenError_finalise_loginErrorGeneric() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        let service = MockOIDAuthorizationServiceNeverStartedAuthenticationSession.mock()

        let configuration: LoginSessionConfiguration = await .stub()
        await #expect(throws: LoginError(.safariOpenError)) {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service
            )
        }

        #expect(throws: LoginError(.generic)) {
            try sut.finalise(redirectURL: URL(string: configuration.redirectURI)!)
        }
    }

    /// This is a use case where **the associated app domains have failed to register with the app** thus
    /// the completionHandler on the ``ASWebAuthenticationSession`` is **never called** due to the fact that the
    /// `/redirect` URL  (aka `callbackURL`) for the associated domain (e.g. https://mobile.account.gov.uk/redirect)
    /// opens in Safari instead.
    ///
    /// That leaves the "authorization session" in a "pending" state that requires an explicit call to
    /// ``resumeExternalUserAgentFlow(with: url)`` with the redirectURL on the  ``OIDExternalUserAgentSession`` instance as returned by the call to the
    ///  ``OIDAuthorizationService/present(configuration:preenting:prefersEphemeralSession:)``
    ///
    /// For any given "user agent session" instance, only one call to ``resumeExternalUserAgentFlow(with: url)`` is permitted.
    ///
    /// This test asserts that a second call to ``AppAuthSession/finalise(redirectURL:)`` returns a ``LoginError``
    ///
    /// - SeeAlso: ``resumeExternalUserAgentFlow(with:)`` on ``OIDAuthorizationSession`` how a succesful completion, calls ``didFinishWithResponse:error:``
    /// which sets `_pendingauthorizationFlowCallback` to nil. Thus any follow up call to ``resumeExternalUserAgentFlow(with:)``
    /// fails the `!_pendingauthorizationFlowCallback` check for an invalid state.
    ///
    @MainActor
    @Test
    func test_given_authorisationFlowNeverCompletes_assert_second_finalise_throws_LoginError() async throws {
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

        Task {
            try await sut.performLoginFlow(
                configuration: configuration,
                service: service)
        }

        _ = await notificationAuthorizationFlowStarted.next()

        // AND a call is made to finalise the "user agent session"
        let redirectURL: URL = authorizationRequest.stubRedirectURL(code: "test-code")
        try sut.finalise(redirectURL: redirectURL)

        // THEN a second finalise throws a LoginError
        #expect(throws: LoginError(.generic).self) {
            try sut.finalise(redirectURL: redirectURL)
        }
    }

    @MainActor
    @Test
    func test_given_authorisationFlowNeverCompletes_and_resumeExternalUserAgentFlow_false_assert_finalise_with_an_invalid_redirect_error() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        // GIVEN a `OIDAuthorizationService` instance that never completes the session
        let service = MockOIDAuthorizationServiceExternalUserAgentPending.mock()

        let configuration = await LoginSessionConfiguration.stub()
        let authorizationRequest = configuration.authorizationRequest
        let errors = MockOIDExternalUserAgentSessionResumeFailExternalUserAgentFlowWithError.FailExternalUserAgentFlowErrors()
        let externalUserAgentSession = MockOIDExternalUserAgentSessionResumeFailExternalUserAgentFlowWithError.make(errors: errors)
        service.stub(authorizationRequest: authorizationRequest, externalUserAgentSession: externalUserAgentSession)

        let notificationAuthorizationFlowStarted = NotificationCenter.default.notifications(
            named: MockOIDAuthorizationServiceExternalUserAgentPending.authorizationFlowStarted,
            object: externalUserAgentSession
        ).makeAsyncIterator()

        Task {
            // WHEN a call to perform a login is made that stores a `OIDExternalUserAgentSession`
            try? await sut.performLoginFlow(configuration: configuration, service: service)
        }

        _ = await notificationAuthorizationFlowStarted.next()

        // AND a call is made to finalise the "user agent session" with a redirect error
        let anyError: OIDError = .accessDenied
        let errorDescription = "anyDescription"
        let redirectURL: URL = authorizationRequest.stubRedirectURL(error: anyError, description: errorDescription)
        // THEN finalise will failExternalUserAgentFlowWithError
        try sut.finalise(redirectURL: redirectURL)

        #expect(!errors.isEmpty)
        var actual = errors.makeIterator()
        let error = try #require(actual.next() as? LoginError)
        #expect(error.kind == .invalidRedirectURL)
        #expect(error.reason == "\(anyError.rawValue): \(errorDescription)")
    }

    // MARK: Finalise tests

    @MainActor
    @Test
    func test_finalise_throwErrorWithNoAuthCode() async throws {
        let sut: AppAuthSession = .makeWithMocks()

        let configuration = await LoginSessionConfiguration.stub()
        let error = #expect(throws: LoginError(.generic).self) {
            try sut.finalise(redirectURL: configuration.authorizationRequest.stubRedirectURL())
        }

        #expect(error?.reason == "User Agent Session does not exist")
    }
}

extension LoginSessionConfiguration {
    static let mock = {
        await LoginSessionConfiguration(
            authorizationEndpoint: URL(
                string: "https://token.build.account.gov.uk/authorize"
            )!,
            tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!,
            clientID: "1234",
            redirectURI: "https://mobile.build.account.gov.uk/redirect"
        )
    }
}

extension LoginSessionConfiguration {
    static func stub(authorizationEndPoint: URL = URL(string: "https://token.build.account.gov.uk/authorize")!,
                     tokenEndPoint: URL = URL(string: "https://token.build.account.gov.uk/token")!,
                     issuer: URL? = URL(string: "https://token.build.account.gov.uk"),
                     audience clientID: String = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
    ) async -> LoginSessionConfiguration {
        await LoginSessionConfiguration(
            authorizationEndpoint: authorizationEndPoint,
            tokenEndpoint: tokenEndPoint,
            issuer: issuer,
            clientID: clientID,
            redirectURI: "https://mobile.build.account.gov.uk/redirect"
        )
    }
}

struct Claims: Codable {
  enum InvalidClaimError: Error, LocalizedError {
      case iatRejection
    
    var errorDescription: String? {
        switch self {
        case .iatRejection:
            return "Issued date (aka `issuedAt`) should not be more than +/- 10 minutes away from the current time"
        }
    }
  }
    
    /// Returns a set of Claims that can be serialised to the following JSON object using default values:
    ///
    ///     {
    ///         "aud": "bYrcuRVvnylvEgYSSbBjwXzHrwJ",
    ///         "iss": "https://token.build.account.gov.uk",
    ///         "sub": "c722338b-b18b-4a6c-80d8-c295e214e379",
    ///         "persistent_id": "af835f3a-b3f1-4b50-b3db-88c185eae46b",
    ///         "iat": [9 minutes from now],
    ///         "exp": [9 minutes from now],
    ///         "nonce": "ocOunJO44mNhS5dZCVB_omA0FJggLP25nM5jsDD4uz0",
    ///         "email": "mock@email.com",
    ///         "email_verified": true,
    ///         "uk.gov.account.token/walletStoreId": "LpyvURud63e1LDVO0AEf7AJvXUrFlCGRfF-tl63vUe0"
    ///     }
    ///
    ///
    /// - Parameters:
    ///   - audience: the "aud" value in the claims
    ///   - issuer: the "iss" value in the claims
    ///   - issuedAt: the "iss" value in the claims; it should not be more than +/- 10 minutes on the current time for a valid claim as expected by the AppAuth validation
    ///   - expiresAt: the date in which it expires;
    static func make(audience aud: String = "bYrcuRVvnylvEgYSSbBjwXzHrwJ",
                     issuer iss: String = "https://token.build.account.gov.uk",
                     issuedAt iat: Date? = nil,
                     expiresAt exp: Date? = nil) throws(InvalidClaimError) -> Claims {
        let current = Calendar.current
        let now = Date()
      
        let iat = iat ?? current.date(byAdding: .init(minute: 9), to: now)!
        let tenMinutes: TimeInterval = 10 * 60
      
        guard fabs(iat.timeIntervalSinceNow) < tenMinutes else {
          throw InvalidClaimError.iatRejection
        }
        
        return Claims(
            aud: aud,
            iss: URL(string: iss)!,
            sub: "c722338b-b18b-4a6c-80d8-c295e214e379",
            persistent_id: "af835f3a-b3f1-4b50-b3db-88c185eae46b",
            iat: iat,
            exp: exp ?? current.date(byAdding: .init(minute: 9), to: now)!,
            nonce: "ocOunJO44mNhS5dZCVB_omA0FJggLP25nM5jsDD4uz0",
            email: "mock@email.com",
            email_verified: true,
            walletStoreId: "LpyvURud63e1LDVO0AEf7AJvXUrFlCGRfF-tl63vUe0",
        )
    }

    let aud: String
    let iss: URL
    let sub: String
    let persistent_id: String
    let iat: Date
    let exp: Date
    let nonce: String
    let email: String
    let email_verified: Bool
    let walletStoreId: String
    
    enum CodingKeys: String, CodingKey {
        case aud
        case iss
        case sub
        case persistent_id
        case iat
        case exp
        case nonce
        case email
        case email_verified
        case walletStoreId = "uk.gov.account.token/walletStoreId"
    }
}

struct Claim {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiryDate: Date
    
    static func make(accessToken: String = "1234567890",
                     tokenType: String = "mock token",
                     refreshToken: String = "0987654321",
                     expiryDate: Date = Date()) -> Claim {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970))
        }
        
        return Claim(
            accessToken: accessToken,
            tokenType: tokenType,
            refreshToken: refreshToken,
            expiryDate: expiryDate,
            encoder: encoder)
    }
    
    let encoder: JSONEncoder
    
    /// Returns a token with the following structure
    ///
    /// ```
    ///    {
    ///        "access_token": "any",
    ///        "refresh_token": "any",
    ///        "id_token": [JWT value],
    ///        "token_type": "token",
    ///        "expires_in": 180
    ///    }
    /// ```
    /// Where the "id_token" has a JWT value of:
    ///
    /// Header:
    /// ```
    ///     {
    ///       "alg": "ES256",
    ///       "typ": "JWT",
    ///       "kid": "16db6587-5445-45d6-a7d9-98781ebdf93d"
    ///     }
    /// ```
    ///
    /// Payload: base64 encoded `Claims` URL safe without padding
    ///
    /// Signature:
    /// ```7ocBIY_vVO83eYlYpJJJuFvl_GtWqwkeYzEDiNjSfUGGatnIW5ahcoEC-tjkIxQhVjpKhmcS_HcE34836OSXrw```
    ///
    /// - SeeAlso: `Claims` on how to create a set of claims with provided values
    func token(_ claims: Claims) throws -> String {
        let payload = try encoder.encode(claims).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "=="))

        let idToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjE2ZGI2NTg3LTU0NDUtNDVkNi1hN2Q5LTk4NzgxZWJkZjkzZCJ9.\(payload)." +
            "7ocBIY_vVO83eYlYpJJJuFvl_GtWqwkeYzEDiNjSfUGGatnIW5ahcoEC-tjkIxQhVjpKhmcS_HcE34836OSXrw"
        
        return """
        {
            "access_token": "\(accessToken)",
            "refresh_token": "\(refreshToken)",
            "id_token": "\(idToken)",
            "token_type": "\(tokenType)",
            "expires_in": \(Int(expiryDate.timeIntervalSince1970))
        }
        """
    }
}

extension AppAuthSession {
    static func makeWithMocks() -> AppAuthSession {
        let window = UIWindow()
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()

        return AppAuthSession(window: window)
    }
}
