import Foundation

// MARK: Authentication
extension URL {
    static var authenticationURL: URL {
        URL(string: "https://oidc.integration.account.gov.uk")!
    }
    
    static var userInfo: URL {
        authenticationURL
            .appendingPathComponent("userinfo")
    }
}
