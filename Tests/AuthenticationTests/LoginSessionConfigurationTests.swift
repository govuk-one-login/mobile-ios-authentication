@testable import Authentication
//import Authentication
import XCTest

final class LoginSessionConfigurationTests: XCTestCase {

    var sut: LoginSessionConfiguration!
        
        override func setUp() {
            super.setUp()
            let url = URL(string: "https://www.google.com")!

            sut = .init(LoginSessionConfiguration(authorizationEndpoint: url, responseType: .code, scopes: [.email], clientID: "1234", prefersEphemeralWebSession: true, redirectURI: "https://www.google.com", nonce: "1234", viewThroughRate: "1", locale: .en))
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
        XCTAssertEqual(sut.redirectURI, "https://www.google.com")
    }
    
    func testNonce() {
        XCTAssertEqual(sut.nonce, "1234")
    }
    
    func testViewThroughRate() {
        XCTAssertEqual(sut.viewThroughRate, "1")
    }
    
    func testLocale() {
        XCTAssertEqual(sut.locale, .en)
    }
}
