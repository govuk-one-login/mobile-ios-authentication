import AppAuthCore


public class MockOIDExternalUserAgentSession_MissingAuthStateToken: NSObject,
                                                                       OIDExternalUserAgentSession {
    var callback: OIDAuthStateAuthorizationCallback?
    
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
        let authResponse = OIDAuthorizationResponse(request: authRequest, parameters: .init())

        let authState: OIDAuthState? = OIDAuthState(authorizationResponse: authResponse,
                                                    tokenResponse: nil)
        let error: Error? = nil
        callback?(authState, error)
        return true
    }
}
