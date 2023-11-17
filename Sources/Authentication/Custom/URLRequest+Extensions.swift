import Foundation

extension URLRequest {
    static func tokenRequest(body: Data, endpoint: URL) -> URLRequest {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
}
