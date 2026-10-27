import AppAuthCore

extension OIDTokenRequest {
    static func mock(endPoint: URL = URL(string: "https://token.build.account.gov.uk/token")!,
                     issuer: URL? = URL(string: "https://token.build.account.gov.uk"),
                     audience clientID: String = "",
                     withAdditionalParameters additionalParameters: [String: String]? = nil,
                     additionalHeaders: [String: String]? = nil
    ) -> OIDTokenRequest {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: URL(
                string: "https://token.build.account.gov.uk/authorize"
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
            additionalParameters: additionalParameters,
            additionalHeaders: additionalHeaders
        )
    }
}
