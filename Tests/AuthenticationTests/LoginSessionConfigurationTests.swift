@testable import Authentication
import XCTest

final class LoginSessionConfigurationTests: XCTestCase {
    
    var sut: LoginSessionConfiguration!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com/authorize")!,
                                              tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                              responseType: .code,
                                              scopes: [.email],
                                              clientID: "1234",
                                              prefersEphemeralWebSession: true,
                                              redirectURI: "https://www.google.com/redirect",
                                              vectorsOfTrust: ["1"],
                                              locale: .en,
                                              persistentSessionId: "123456789")
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension LoginSessionConfigurationTests {
    func test_hasAuthorizationURL() {
        XCTAssertEqual(sut.authorizationEndpoint, URL(string: "https://www.google.com/authorize"))
    }
    
    func test_sutHasTokenURL() {
        XCTAssertEqual(sut.tokenEndpoint, URL(string: "https://www.google.com/token"))
    }
    
    func test_responseType() {
        XCTAssertEqual(sut.responseType, .code)
    }
    
    func test_scope() {
        XCTAssertEqual(sut.scopes, [.email])
    }
    
    func test_clientID() {
        XCTAssertEqual(sut.clientID, "1234")
    }
    
    func test_prefersEphemeralWebSession() {
        XCTAssertTrue(sut.prefersEphemeralWebSession)
    }
    
    func test_redirectURI() {
        XCTAssertEqual(sut.redirectURI, "https://www.google.com/redirect")
    }
    
    func test_vectorsOfTrust() {
        XCTAssertEqual(sut.vectorsOfTrust, ["1"])
    }
    
    func test_locale() {
        XCTAssertEqual(sut.locale, .en)
    }
    
    func test_persistentSessionId() {
        XCTAssertEqual(sut.persistentSessionId, "123456789")
    }
    
    func test_defaultValues() async {
        sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                              tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                              clientID: "1234",
                                              redirectURI: "https://www.google.com/redirect")
        XCTAssertEqual(sut.responseType, .code)
        XCTAssertEqual(sut.scopes, [.openid, .email, .phone, .offline_access])
        XCTAssertTrue(sut.prefersEphemeralWebSession)
        XCTAssertEqual(sut.vectorsOfTrust, ["Cl.Cm.P0"])
        XCTAssertEqual(sut.vectorsOfTrust.description, "[\"Cl.Cm.P0\"]")
        XCTAssertNil(sut.persistentSessionId)
    }
    
    func test_serviceConfiguration() {
        XCTAssertEqual(sut.serviceConfiguration.authorizationEndpoint, URL(string: "https://www.google.com/authorize"))
        XCTAssertEqual(sut.serviceConfiguration.tokenEndpoint, URL(string: "https://www.google.com/token"))
    }
    
    func test_authorizationRequest() {
        XCTAssertEqual(sut.authorizationRequest.scope, "email")
        XCTAssertEqual(sut.authorizationRequest.redirectURL, URL(string: "https://www.google.com/redirect"))
        XCTAssertEqual(sut.authorizationRequest.responseType, "code")
        XCTAssertEqual(
            sut.authorizationRequest.additionalParameters,
            [
                "vtr": "[\"1\"]",
                "ui_locales": "en",
                "govuk_signin_session_id": "123456789"
            ]
        )
    }
}
