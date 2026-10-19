@preconcurrency import AppAuthCore

extension OIDAuthorizationRequest {
    static func mock(endPoint: URL = URL(string: "https://token.build.account.gov.uk/token")!,
                     redirectURL: URL = URL(string: "https://mobile.build.account.gov.uk/redirect")!,
                     clientId: String = "",
                     scopes: [String]? = nil,
                     responseType: String = "code",
                     additionalParameters: [String: String] = [:]
    ) -> OIDAuthorizationRequest {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: endPoint,
            tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!
        )
        return OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: clientId,
            scopes: scopes,
            redirectURL: redirectURL,
            responseType: responseType,
            additionalParameters: additionalParameters
        )
    }
}
