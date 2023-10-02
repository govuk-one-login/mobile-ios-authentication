import Foundation

// MARK: Backend
extension URL {
    static var backendURL: URL {
        URL(string: "https://api-app-login-spike-be.review-b.dev.account.gov.uk")!
    }
    
    static var token: URL {
        backendURL
            .appendingPathComponent("app")
            .appendingPathComponent("token")
    }
}
