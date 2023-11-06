import Foundation

public struct LoginSessionConfiguration {
    public let authorizationEndpoint: URL
    public let tokenEndpoint: URL
    public let responseType: ResponseType
    public let scopes: [Scope]
    
    public let clientID: String
    
    public let prefersEphemeralWebSession: Bool
    
    public let redirectURI: String
    
    public let viewThroughRate: String
    public let locale: UILocale
    
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
                viewThroughRate: String = "[\"Cl.Cm.P0\"]",
                locale: UILocale = .en) {
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.responseType = responseType
        self.scopes = scopes
        self.clientID = clientID
        self.prefersEphemeralWebSession = prefersEphemeralWebSession
        self.redirectURI = redirectURI
        self.viewThroughRate = viewThroughRate
        self.locale = locale
    }
}
