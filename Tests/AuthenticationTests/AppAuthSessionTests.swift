@testable import Authentication
import XCTest

final class AppAuthSessionTests: XCTestCase {
    var sut: AppAuthSession!
    var config = LoginSessionConfiguration.mock
    
    override func setUp() {
        super.setUp()
        let window = UIWindow()
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        sut = .init(window: window)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

extension AppAuthSessionTests {
    func test_finalise_throwErrorWithNoAuthCode() async throws {
        do {
            _ = try await sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "User Agent Session does not exist")
        }
    }
    
    @MainActor
    func test_finaliseAuthService_rejectsIncorrectStateParameter() throws {
        let exp = expectation(description: "wait for token response")
        Task {
            do {
                _ = try await sut.performLoginFlow(configuration: .mock)
            } catch LoginError.generic(let description) {
                XCTAssertTrue(description.starts(with: "State mismatch"))
                exp.fulfill()
            }
        }
        
        waitForTruth(self.sut.isActive, timeout: 2)
        
        let code = UUID().uuidString
        let randomState = UUID().uuidString
        try sut.finalise(redirectURL: URL(string: "https://www.google.com?code=\(code)&state=\(randomState)")!)
        
        wait(for: [exp], timeout: 2)
    }
    
    @MainActor
    func test_finaliseAuthService_rejectsWhenNoAuthState() async throws {
        Task {
            try await sut.performLoginFlow(configuration: .mock)
        }
        
        do {
            try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "No authState")
        }
    }
    
    @MainActor
    func test_finaliseAuthService_rejectsWhenAuthStateMissingToken() async throws {
        Task {
            try await sut.performLoginFlow(configuration: .mock)
        }
        
        do {
            try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "Missing authState Token Response")
        }
    }
    
    @MainActor
    func test_finaliseAuthService_rejectsWhenAuthStateMissingProperty() async throws {
        Task {
            try await sut.performLoginFlow(configuration: .mock)
        }
        
        do {
            try sut.finalise(redirectURL: URL(string: "https://www.google.com")!)
        } catch LoginError.generic(let description) {
            XCTAssertTrue(description == "Missing authState property")
        }
    }
}

extension LoginSessionConfiguration {
    static let mock = LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://www.google.com")!,
                                                tokenEndpoint: URL(string: "https://www.google.com/token")!,
                                                clientID: "1234",
                                                redirectURI: "https://www.google.com")
}
