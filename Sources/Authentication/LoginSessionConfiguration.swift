import Foundation

public struct LoginSessionConfiguration {
    let authorizationEndpoint: URL
    let tokenEndpoint: URL
    let responseType: ResponseType
    let scopes: [Scope]
    
    let clientID: String
    
    let prefersEphemeralWebSession: Bool
    
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
                tokenEndpoint: URL,
                responseType: ResponseType = .code,
                scopes: [Scope] = [.openid, .email, .phone, .offline_access],
                clientID: String,
                prefersEphemeralWebSession: Bool = true,
                redirectURI: String,
                nonce: String = UUID().uuidString,
                viewThroughRate: String = "[Cl.Cm.P0]",
                locale: UILocale = .en) {
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
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
