@testable import Authentication
import XCTest

final class LoginSessionConfigurationTests: XCTestCase {
    
    var sut: LoginSessionConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        responseType: .code,
                                        scopes: [.email],
                                        clientID: "1234",
                                        prefersEphemeralWebSession: true,
                                        redirectURI: "https://www.google.com/redirect",
                                        nonce: "1234",
                                        viewThroughRate: "1",
                                        locale: .en)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension LoginSessionConfigurationTests {
    func testSUTHasAuthorizationURL() {
        XCTAssertEqual(sut.authorizationEndpoint, URL(string: "https://www.google.com"))
    }
    
    func testSUTHasTokenURL() {
        XCTAssertEqual(sut.tokenEndpoint, URL(string: "https://www.google.com/token"))
    }
    
    func testResponseType() {
        XCTAssertEqual(sut.responseType, .code)
    }
    
    func testDefaultResponseType() {
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        clientID: "1234",
                                        redirectURI: "https://www.google.com/redirect")
        XCTAssertEqual(sut.responseType, .code)
    }
    
    func testScope() {
        XCTAssertEqual(sut.scopes, [.email])
    }
    
    func testDefaultScope() {
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        clientID: "1234",
                                        redirectURI: "https://www.google.com/redirect")
        XCTAssertEqual(sut.scopes, [.openid, .email, .phone, .offline_access])
    }
    
    func testClientID() {
        XCTAssertEqual(sut.clientID, "1234")
    }
    
    func testPrefersEphemeralWebSession() {
        XCTAssertTrue(sut.prefersEphemeralWebSession)
    }
    
    func testDefaultPrefersEphemeralWebSession() {
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        clientID: "1234",
                                        redirectURI: "https://www.google.com/redirect")
        XCTAssertFalse(sut.prefersEphemeralWebSession)
    }
    
    func testRedirectURI() {
        XCTAssertEqual(sut.redirectURI, "https://www.google.com/redirect")
    }
    
    func testNonce() {
        XCTAssertEqual(sut.nonce, "1234")
    }
    
    func testViewThroughRate() {
        XCTAssertEqual(sut.viewThroughRate, "1")
    }
    
    func testDefaultViewThroughRate() {
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        clientID: "1234",
                                        redirectURI: "https://www.google.com/redirect")
        XCTAssertEqual(sut.viewThroughRate, "[Cl.Cm.P0]")
    }
    
    func testLocale() {
        XCTAssertEqual(sut.locale, .en)
    }
    
    
}
