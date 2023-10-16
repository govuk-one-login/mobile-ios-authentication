@testable import UserDetails
@testable import Networking

import MockNetworking
import XCTest

final class UserServiceTests: XCTestCase {

    var sut: UserService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let client = NetworkClient(configuration: configuration)
        
        sut = UserService(client: client)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_fetchUserInfo_returnData() async throws {
        
        let jsonString = """
{
  "sub": "some sub",
  "phone_number_verified": true,
  "phone_number": "1234567890",
  "email_verified": false,
  "email": "test@test.com"
}
"""
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("unable to convert to data")
            return
        }
        
        MockURLProtocol.handler = {
            (jsonData, HTTPURLResponse(statusCode: 200))
        }
        
        let userInfo = try await sut.fetchUserInfo()
        
        XCTAssertEqual(userInfo.email, "test@test.com")
        
    }
    
    func test_fetchUserInfo_throwErrorWithMalformedData() async throws {
        
        let jsonString = """
{
  "sub": "some sub",
  "phone_number_verified": "12345",
  "phone_number": "1234567890",
  "email_verified": false,
  "email": "test@test.com"
}
"""
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("unable to convert to data")
            return
        }
        
        MockURLProtocol.handler = {
            (jsonData, HTTPURLResponse(statusCode: 200))
        }
        
        do {
           _ = try await sut.fetchUserInfo()
            XCTFail("Should not continue with malformed data")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
