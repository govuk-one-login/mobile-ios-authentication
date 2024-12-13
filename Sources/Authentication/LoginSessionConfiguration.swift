import AppAuthCore
import Foundation

public typealias TokenParameters = [String: String]
public typealias TokenHeaders = [String: String]

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
    public let tokenParameters: () async throws -> TokenParameters?
    public let tokenHeaders: () async throws -> TokenHeaders?
    
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
    
    public init(
        authorizationEndpoint: URL,
        tokenEndpoint: URL,
        responseType: ResponseType = .code,
        scopes: [Scope] = [.openid, .email, .phone, .offline_access],
        clientID: String,
        prefersEphemeralWebSession: Bool = true,
        redirectURI: String,
        vectorsOfTrust: [String] = ["Cl.Cm.P0"],
        locale: UILocale = .en,
        persistentSessionId: String? = nil,
        tokenParameters: @escaping @autoclosure () async throws -> TokenParameters? = nil,
        tokenHeaders: @escaping @autoclosure () async throws -> TokenHeaders? = nil
    ) async {
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
        self.tokenParameters = tokenParameters
        self.tokenHeaders = tokenHeaders
    }
}

extension LoginSessionConfiguration {
    var serviceConfiguration: OIDServiceConfiguration {
        OIDServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint
        )
    }
    
    var authorizationRequest: OIDAuthorizationRequest {
        OIDAuthorizationRequest(
            configuration: serviceConfiguration,
            clientId: clientID,
            scopes: scopes.map(\.rawValue),
            redirectURL: URL(string: redirectURI)!,
            responseType: responseType.rawValue,
            additionalParameters: {
                var params = [
                    "vtr": vectorsOfTrust.description,
                    "ui_locales": locale.rawValue
                ]
                if let persistentSessionId {
                    params["govuk_signin_session_id"] = persistentSessionId
                }
                return params
            }()
        )
    }
}
