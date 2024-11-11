import AppAuthCore

public class MockOIDExternalUserAgentSession_Perform_ClientError: NSObject,
                                                                  OIDExternalUserAgentSession {
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let serviceConfiguration = OIDServiceConfiguration(
            authorizationEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!,
            tokenEndpoint: Foundation.URL(
                string: "https://www.google.com"
            )!
        )
        let authRequest = OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: "",
            scopes: nil,
            redirectURL: Foundation.URL(
                string: "https://www.google.com"
            )!,
            responseType: "code",
            additionalParameters: .init()
        )
        let authorizationResponse = MockAuthorizationResponse(
            request: authRequest,
            parameters: .init()
        )
        
        callback?(authorizationResponse, nil)
        return true
    }
}

class MockAuthorizationResponse: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String: String]?,
        additionalHeaders: [String: String]?
    ) -> OIDTokenRequest? {
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
