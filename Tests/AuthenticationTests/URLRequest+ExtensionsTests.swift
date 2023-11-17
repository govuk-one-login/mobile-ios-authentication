@testable import Authentication
import XCTest

class URLRequestExtensionsTests: XCTestCase {
    func test_tokenRequestURL() throws {
        let authorizationCode = "123456789"
        let requestBody = try JSONEncoder()
            .encode(TokenRequest(authorizationCode: authorizationCode))
        let url = URL(string: "https://www.google.com/token")!
        let sut = URLRequest.tokenRequest(body: requestBody, endpoint: url)
        XCTAssertEqual(sut.url, url)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
}
