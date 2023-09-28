import Foundation

public struct LoginSessionConfiguration {
    let authorizationEndpoint: URL
    let responseType: ResponseType
    let scopes: [Scope]
    
    let clientID: String
    
    let prefersEphemeralWebSession: Bool
    let state: String = UUID().uuidString
    
    let redirectURI: String
    
    let nonce: String
    let viewThroughRate: String
    let locale: UILocale
    
    public enum ResponseType: String {
        case code
    }
    
    public enum Scope: String, CaseIterable {
        case openid
        case email
        case phone
        case offline_access
    }
    
    public enum UILocale: String {
        case en
        case cy
    }
    
    public init(authorizationEndpoint: URL,
                responseType: ResponseType,
                scopes: [Scope],
                clientID: String,
                prefersEphemeralWebSession: Bool,
                redirectURI: String,
                nonce: String,
                viewThroughRate: String,
                locale: UILocale) {
        self.authorizationEndpoint = authorizationEndpoint
        self.responseType = responseType
        self.scopes = scopes
        self.clientID = clientID
        self.prefersEphemeralWebSession = prefersEphemeralWebSession
        self.redirectURI = redirectURI
        self.nonce = nonce
        self.viewThroughRate = viewThroughRate
        self.locale = locale
    }
}
