import Foundation

extension URLRequest {
    static func tokenRequest(body: Data) -> URLRequest {
        var request = URLRequest(url: .token)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
}
