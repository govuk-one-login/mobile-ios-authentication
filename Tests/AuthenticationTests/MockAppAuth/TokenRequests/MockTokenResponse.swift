@preconcurrency import AppAuthCore

final class MockTokenResponse: OIDTokenResponse {
    struct Response {
        static let empty: Response = .init(accessToken: nil,
                                           tokenType: nil,
                                           refreshToken: nil,
                                           idToken: nil,
                                           accessTokenExpirationDate: nil)
        let accessToken: String?
        let tokenType: String?
        let refreshToken: String?
        let idToken: String?
        let accessTokenExpirationDate: Date?
    }

    override var accessToken: String? {
        response.accessToken
    }

    override var tokenType: String? {
        response.tokenType
    }

    override var refreshToken: String? {
        response.refreshToken
    }

    override var idToken: String? {
        response.idToken
    }

    override var accessTokenExpirationDate: Date? {
        response.accessTokenExpirationDate
    }

    private let response: Response

    init(response: Response) {
        self.response = response
        super.init(request: .mock(), parameters: [:])
    }

    override init(request: OIDTokenRequest, parameters: [String : any NSCopying & NSObjectProtocol]) {
        self.response = Response.empty
        super.init(request: request, parameters: parameters)
    }

    required init?(coder: NSCoder) {
        self.response = Response.empty
        super.init(coder: coder)
    }
}
