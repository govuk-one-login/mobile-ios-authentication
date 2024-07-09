import Foundation

public struct LoginSessionConfiguration {
    public let authorizationEndpoint: URL
    public let tokenEndpoint: URL
    public let responseType: ResponseType
    public let scopes: [Scope]
    
    public let clientID: String
    
    public let prefersEphemeralWebSession: Bool
    
    public let redirectURI: String
    
    public let vectorsOfTrust: [String]
    public let locale: UILocale
    public let persistentSessionId: String?
    
    public enum ResponseType: String {
        case code
    }
    
    public enum Scope: Equatable {
        case openid
        case email
        case phone
        case offline_access
        case custom(String)
        
        var rawValue: String {
            switch self {
            case .openid:
                "openid"
            case .email:
                "email"
            case .phone:
                "phone"
            case .offline_access:
                "offline_access"
            case .custom(let scope):
                scope
            }
        }
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
                vectorsOfTrust: [String] = ["Cl.Cm.P0"],
                locale: UILocale = .en,
                persistentSessionId: String? = nil) {
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.responseType = responseType
        self.scopes = scopes
        self.clientID = clientID
        self.prefersEphemeralWebSession = prefersEphemeralWebSession
        self.redirectURI = redirectURI
        self.vectorsOfTrust = vectorsOfTrust
        self.locale = locale
        self.persistentSessionId = persistentSessionId
    }
}
