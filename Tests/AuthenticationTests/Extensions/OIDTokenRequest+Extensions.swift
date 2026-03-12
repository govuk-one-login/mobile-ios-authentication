import AppAuthCore
extension OIDTokenRequest {
    
    static func mock(endPoint: URL = URL(string: "https://token.account.gov.uk/token")!, issuer: URL?, audience clientID: String = "") -> OIDTokenRequest {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: URL(
                string: "https://token.account.gov.uk/authorize"
            )!,
            tokenEndpoint: endPoint,
            issuer: issuer
        )
        return OIDTokenRequest(
            configuration: serviceConfiguration,
            grantType: "",
            authorizationCode: nil,
            redirectURL: nil,
            clientID: clientID,
            clientSecret: nil,
            scope: nil,
            refreshToken: nil,
            codeVerifier: nil,
            additionalParameters: nil,
            additionalHeaders: nil
        )
    }
    
    static var mockTokenRequest: OIDTokenRequest = .mock(issuer: nil)
}
