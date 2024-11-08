import AppAuthCore

// swiftlint:disable type_name
public class MockOIDExternalUserAgentSession_MissingAuthStateToken: NSObject,
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
        
        let authorizationState = MockAuthorizationResponse_MissingTokenState(request: authRequest, parameters: .init())
        
        let error: Error? = nil
        callback?(authorizationState, error)
        return true
    }
}

class MockAuthorizationResponse_MissingTokenState: OIDAuthorizationResponse {
    override func tokenExchangeRequest(
        withAdditionalParameters additionalParameters: [String : String]?,
        additionalHeaders: [String : String]?
    ) -> OIDTokenRequest? {
        nil
    }
}
