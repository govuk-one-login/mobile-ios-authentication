@testable import Authentication
import XCTest

class URLRequestExtensionsTests: XCTestCase {
    func test_tokenRequestURL() throws {
        let authorizationCode = "123456789"
        let requestBody = TokenRequest(authorizationCode: authorizationCode, redirectURI: "123456789")
        let url = URL(string: "https://www.google.com/token")!
        let sut = URLRequest.tokenRequest(requestBody: requestBody, endpoint: url)
        XCTAssertEqual(sut.url, url)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(sut.httpBody, "grant_type=authorization_code&code=123456789&redirect_uri=123456789".data(using: .utf8))
    }
}
