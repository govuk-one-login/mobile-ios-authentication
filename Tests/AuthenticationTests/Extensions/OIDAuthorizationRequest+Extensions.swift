import AppAuthCore

extension OIDAuthorizationRequest {
    static var mockAuthorizationRequest: OIDAuthorizationRequest {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        return OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: "",
            scopes: nil,
            redirectURL: Foundation.URL(
                string: "https://www.google.com"
            )!,
            responseType: "code",
            additionalParameters: .init()
        )
    }
}
