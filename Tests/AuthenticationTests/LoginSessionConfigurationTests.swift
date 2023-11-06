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
    
    func testScope() {
        XCTAssertEqual(sut.scopes, [.email])
    }
    
    func testClientID() {
        XCTAssertEqual(sut.clientID, "1234")
    }
    
    func testPrefersEphemeralWebSession() {
        XCTAssertTrue(sut.prefersEphemeralWebSession)
    }
    
    func testRedirectURI() {
        XCTAssertEqual(sut.redirectURI, "https://www.google.com/redirect")
    }
    
    func testViewThroughRate() {
        XCTAssertEqual(sut.viewThroughRate, "1")
    }
    
    func testLocale() {
        XCTAssertEqual(sut.locale, .en)
    }
    
    func testDefaultValues() {
        sut = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                        tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                        clientID: "1234",
                                        redirectURI: "https://www.google.com/redirect")
        XCTAssertEqual(sut.responseType, .code)
        XCTAssertEqual(sut.scopes, [.openid, .email, .phone, .offline_access])
        XCTAssertTrue(sut.prefersEphemeralWebSession)
        XCTAssertEqual(sut.viewThroughRate, "[Cl.Cm.P0]")
    }
}
