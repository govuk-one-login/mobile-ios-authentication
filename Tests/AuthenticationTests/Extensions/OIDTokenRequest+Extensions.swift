import AppAuthCore

extension OIDTokenRequest {
    static var mockTokenRequest: OIDTokenRequest {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        return OIDTokenRequest(
            configuration: serviceConfiguration,
            grantType: "",
            authorizationCode: nil,
            redirectURL: nil,
            clientID: "",
            clientSecret: nil,
            scope: nil,
            refreshToken: nil,
            codeVerifier: nil,
            additionalParameters: nil,
            additionalHeaders: nil
        )
    }
}
