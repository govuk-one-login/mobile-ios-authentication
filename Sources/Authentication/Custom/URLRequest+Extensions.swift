import Foundation

extension URLRequest {
    static func tokenRequest(requestBody: TokenRequest, endpoint: URL) -> URLRequest {
        var urlParser = URLComponents()
        urlParser.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: requestBody.authorizationCode),
            URLQueryItem(name: "redirect_uri", value: requestBody.redirectURI)
        ]
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = urlParser.percentEncodedQuery?.data(using: .utf8)
        return request
    }
}
