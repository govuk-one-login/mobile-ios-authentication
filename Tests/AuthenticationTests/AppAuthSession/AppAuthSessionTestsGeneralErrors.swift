// swiftlint:disable file_length
@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    var sut: AppAuthSession!
    var config = LoginSessionConfiguration.mock
    
    @MainActor
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        sut = AppAuthSession(window: window)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension AppAuthSessionTests {
    
    // MARK: A suite of tests on ID token verification
    // A Suite of tests that assert the validity of an ID token in the format expected to be issued by STS.
    
    @MainActor
    func test_loginFlow_succeeds_validation() throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request matches the audience
        //  ASSERT that no (validation) error occured
        let exp = expectation(description: #function)
        
        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: endPoint, session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: audience))))

        // When
        var caughtError: Error?

        Task {
            do {
                let tokens = try await self.sut.performLoginFlow(
                    configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience),
                    service: service)
                XCTAssertNotNil(tokens)
            } catch {
                caughtError = error
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)

        // Then
        XCTAssertNil(caughtError)
    }
    
    @MainActor
    func test_loginFlow_fails_validation_issuer_mismatch() throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request DOES NOT match the issuer
        //  AND the request matches the audience
        //  ASSERT that a login error occured for the issuer mismatch
        let exp = expectation(description: #function)

        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let mismatchedIssuer = "https://invalid.gov.uk"
        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: endPoint,
                     session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: mismatchedIssuer), audience: audience))))

        // When
        var caughtError: Error?

        Task {
            do {
                let tokens = try await self.sut.performLoginFlow(
                    configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: mismatchedIssuer), audience: audience),
                    service: service)
                XCTAssertNotNil(tokens)
            } catch {
                caughtError = error
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)

        XCTAssertNotNil(caughtError)
        let le = caughtError as? LoginError
        XCTAssertEqual(le?.reason, "Issuer mismatch")
    }

    @MainActor
    func test_loginFlow_fails_validation_audience_mismatch() throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request DOES NOT match the audience
        //  ASSERT that a login error occured for the audience mismatch
        let exp = expectation(description: #function)

        // Given a token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.account.gov.uk"

        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let invalidAudience = "invalid aud"
        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: endPoint,
                     session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: invalidAudience))))

        // When
        var caughtError: Error?

        Task {
            do {
                let tokens = try await self.sut.performLoginFlow(
                    configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience),
                    service: service)
                XCTAssertNotNil(tokens)
            } catch {
                caughtError = error
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)

        XCTAssertNotNil(caughtError)
        let le = caughtError as? LoginError
        XCTAssertEqual(le?.reason, "Audience mismatch")
    }
    
    @MainActor
    func test_loginFlow_fails_validation_token_expired() throws {
        //  GIVEN an ID token
        //  AND the iss claim equals https://token.account.gov.uk
        //  AND the aud claim equals bYrcuRVvnylvEgYSSbBjwXzHrwJ
        //  AND the token has long EXPIRED
        //  WHEN performing a login
        //  AND the request matches the issuer
        //  AND the request matches the audience
        //  ASSERT that a login error occured for the expired id token
        let exp = expectation(description: #function)

        // Given an EXPIRED token
        let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
        let issuer = "https://token.account.gov.uk"
      
        let unique = UUID().uuidString
        let endPoint = URL(string: "https://token.account.gov.uk/token?u=\(unique)")!

        let claims = try Claims.make(audience: audience, issuer: issuer, expiresAt: Date.distantPast)
        try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)

        let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
        service.stub(endPoint: endPoint,
                     session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: audience))))
        
        // When
        var caughtError: Error?

        Task {
            do {
                let tokens = try await self.sut.performLoginFlow(
                    configuration: .stub(tokenEndPoint: endPoint, issuer: URL(string: issuer), audience: audience),
                    service: service)
                XCTAssertNotNil(tokens)
            } catch {
                caughtError = error
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 5)

        XCTAssertNotNil(caughtError)
        let le = caughtError as? LoginError
        XCTAssertEqual(le?.reason, "ID Token expired")
    }

    // MARK: end of suite

    @MainActor
    func test_loginFlow_succeeds() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                let tokens = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_Success.self
                )
                XCTAssertEqual(tokens.accessToken, "1234567890")
                XCTAssertEqual(tokens.tokenType, "mock token")
                XCTAssertEqual(tokens.refreshToken, "0987654321")
                XCTAssertEqual(tokens.idToken, "mock user")
                XCTAssertNotNil(tokens.expiryDate)
            } catch {
                XCTFail("Expected tokens, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_userCancelled() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_UserCancelled.self
                )
                XCTFail("Expected user cancelled error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .userCancelled)
            } catch {
                XCTFail("Expected user cancelled error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_programCancelled() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_ProgramCancelled.self
                )
                XCTFail("Expected user cancelled error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .programCancelled)
            } catch {
                XCTFail("Expected user cancelled error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)

        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_networkError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_NetworkError.self
                )
                XCTFail("Expected network error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .network)
            } catch {
                XCTFail("Expected network error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_generalServerError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_GeneralServerError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .generalServerError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    @MainActor
    func test_loginFlow_safariOpenError() throws {
        let exp = expectation(description: "Wait for token response")
        
        Task {
            do {
                _ = try await sut.performLoginFlow(
                    configuration: .mock(),
                    service: MockOIDAuthorizationService_SafariOpenError.self
                )
                XCTFail("Expected server error, got success")
            } catch let error as LoginError {
                XCTAssertEqual(error.kind, .safariOpenError)
            } catch {
                XCTFail("Expected server error, got \(error)")
            }
            
            exp.fulfill()
        }
        
        waitForTruth(self.sut.isActive, timeout: 10)
        
        try sut.finalise(redirectURL: redirectURL)
        
        wait(for: [exp], timeout: 10)
    }
    
    // MARK: Finalise tests

    @MainActor
    func test_finalise_throwErrorWithNoAuthCode() throws {
        do {
            _ = try sut.finalise(redirectURL: redirectURL)
            XCTFail("Expected user agent session does not exist error, got success")
        } catch let error as LoginError {
            XCTAssertEqual(error.kind, .generic)
            XCTAssertEqual(error.reason, "User Agent Session does not exist")
        } catch {
            XCTFail("Expected user agent session does not exist error, got \(error)")
        }
    }
    
    var redirectURL: URL {
        get throws {
            try XCTUnwrap(
                URL(string: "https://www.gov.uk")
            )
        }
    }
}

extension LoginSessionConfiguration {
    static let mock = {
        await LoginSessionConfiguration(
            authorizationEndpoint: URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: URL(string: "https://www.google.com/token")!,
            clientID: "1234",
            redirectURI: "https://www.google.com"
        )
    }
}

extension LoginSessionConfiguration {
    static func stub(tokenEndPoint: URL = URL(string: "https://token.account.gov.uk/token")!,
                     issuer: URL? = URL(string: "https://token.account.gov.uk"), audience clientID: String = "bYrcuRVvnylvEgYSSbBjwXzHrwJ") async -> LoginSessionConfiguration {
        await LoginSessionConfiguration(
            authorizationEndpoint: URL(
                string: "https://token.account.gov.uk/authorize"
            )!,
            tokenEndpoint: tokenEndPoint,
            issuer: issuer,
            clientID: clientID,
            redirectURI: "https://mobile.account.gov.uk/redirect"
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
    ///         "iss": "https://token.account.gov.uk",
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
                     issuer iss: String = "https://token.account.gov.uk",
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
    
    static func make() -> Claim {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970))
        }
        
        return Claim(encoder: encoder)
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
            "access_token": "any",
            "refresh_token": "any",
            "id_token": "\(idToken)",
            "token_type": "token",
            "expires_in": 180
        }
        """
    }
}
