@testable import Authentication
import XCTest

class URLRequestExtensionsTests: XCTestCase {
    func test_tokenRequestURL() throws {
        let authorizationCode = "123456789"
        let requestBody = TokenRequest(authorizationCode: authorizationCode, redirectURI: "1234").formEncoded
        let url = URL(string: "https://www.google.com/token")!
        let sut = URLRequest.tokenRequest(body: requestBody, endpoint: url)
        XCTAssertEqual(sut.url, url)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
    }
}
