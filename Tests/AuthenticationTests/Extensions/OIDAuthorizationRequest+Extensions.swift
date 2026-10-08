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

    func stubRedirectURL(code: String = "test-code") -> URL {
        var redirect = URLComponents(url: self.redirectURL!, resolvingAgainstBaseURL: false)!
        redirect.queryItems = [URLQueryItem(name: "code", value: code)]
        if let state = self.state {
            redirect.queryItems?.append(URLQueryItem(name: "state", value: state))
        }

        return redirect.url!
    }
}
