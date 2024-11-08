import AppAuthCore

// swiftlint:disable type_name
public class MockOIDExternalUserAgentSession_MissingAuthStateProperty: NSObject,
                                                                       OIDExternalUserAgentSession {
// swiftlint:enable type_name
    var callback: OIDAuthorizationCallback?
    
    public func cancel() { }
    
    public func cancel() async { }
    
    public func failExternalUserAgentFlowWithError(_ error: Error) { }
    
    public func resumeExternalUserAgentFlow(with URL: URL) -> Bool {
        let serviceConfiguration = OIDServiceConfiguration(authorizationEndpoint: Foundation.URL(string: "https://www.google.com")!,
                                                           tokenEndpoint: Foundation.URL(string: "https://www.google.com")!)
        let authRequest = OIDAuthorizationRequest(configuration: serviceConfiguration,
                                                  clientId: "",
                                                  scopes: nil,
                                                  redirectURL: Foundation.URL(string: "https://www.google.com")!,
                                                  responseType: "code",
                                                  additionalParameters: .init())
        let authorizationResponse = MockAuthorizationResponse_MissingAuthState(request: authRequest, parameters: .init())
        let error: Error? = nil
        callback?(authorizationResponse, error)
        return true
    }
}

class MockAuthorizationResponse_MissingAuthState: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String : String]?,
        additionalHeaders: [String : String]?
    ) -> OIDTokenRequest? {
        let serviceConfiguration = OIDServiceConfiguration(authorizationEndpoint: Foundation.URL(string: "https://www.google.com")!,
                                                           tokenEndpoint: Foundation.URL(string: "https://www.google.com")!)
        return OIDTokenRequest(configuration: serviceConfiguration,
                                           grantType: "",
                                           authorizationCode: nil,
                                           redirectURL: nil,
                                           clientID: "",
                                           clientSecret: nil,
                                           scope: nil,
                                           refreshToken: nil,
                                           codeVerifier: nil,
                                           additionalParameters: .init(),
                                           additionalHeaders: .init())
    }
}
