@preconcurrency import AppAuthCore
import UIKit

/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` while still being able to perform a token request
/// i.e. ``OIDTokenRequest``.
///
/// Using this service also allows you to provide a stubbed response, i.e. ``OIDAuthorizationResponse``, for any token request used at
/// ``performTokenRequest:originalAuthorizationResponse:callback:``.
///
/// This mock ensures that any token requests used to retrieve a token will NOT hit the network. Any othere requests will not be attempted.
///
/// e.g.
///     ```
///     let audience = "bYrcuRVvnylvEgYSSbBjwXzHrwJ"
///     let issuer = "https://token.build.account.gov.uk"
///     let endPoint = URL(string: "https://token.build.account.gov.uk/token")!
///
///     let claims = try Claims.make(audience: audience, issuer: issuer)
///     try MockTokenURLProtocol.token(endPoint: endPoint, stub: claims)
///
///     let service = PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.mock()
///
///     service.stub(endPoint: endPoint, session: .mock(authorizationResponse: .mock(mockTokenRequest: .mock(endPoint: endPoint, issuer: URL(string: issuer), audience: audience))))
///
///     service.present(
///         configuration.authorizationRequest,
///         presenting: viewController,
///         prefersEphemeralSession: configuration.prefersEphemeralWebSession) { authResponse, error in
///             let tokenRequest = authorizationResponse.tokenExchangeRequest()
///             service.perform(tokenRequest, originalAuthorizationResponse: authResponse) { tokenResponse, error in
///             }
///         }
///     ```
///
/// - SeeAlso: ``mock(session:)`` to create a new ``PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest`` mock
/// - SeeAlso: ``MockTokenURLProtocol`` on how to stub a token for a token request
@MainActor
final class PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest: OIDAuthorizationService {

    /// Creates a new partial mock that can be used to perform token requests.
    ///
    /// Once you have created a mock, use ``stub(endPoint:session:)`` to provide a stub session prior to performing a token request.
    ///
    static func mock() -> PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.Type {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockTokenURLProtocol.self]
        let session = URLSession(configuration: configuration)
        OIDURLSessionProvider.setSession(session)
        
        return PartialMockOIDAuthorizationServiceAllowsPerformTokenRequest.self
    }
    
    ///
    /// - Parameters
    ///   - endPoint: the URL of the token end point for which you will be making a token request at.
    ///   - sesssion: a succesful user agent session to be returned by ``present(_:presenting:prefersEphemeralSession:callback)``
    /// - SeeAlso: ``OIDExternalUserAgentSession/mock(authorizationResponse:)`` on how to create a mock agent session
    public static func stub(endPoint url: URL, session: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow) {
        Self.stubSessions[url] = (session)
    }
    
    private static var stubSessions: [URL: MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow] = [:]
    
    public override class func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        guard let session = Self.stubSessions[request.configuration.authorizationEndpoint] else {
            return MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow()
        }
        
        DispatchQueue.main.async {
            callback(session.authorizationResponse, nil)
        }

        session.callback = callback
        return session
    }
}

/// Use this ``URLProtocol`` to provide stub tokens and handle any token request without hitting the network.
/// Any othere requests will not be attempted by this protocol.
///
/// Any token request **must** must adhere to *at least* the following properties
/// * **host:** *token.account.gov.uk*
/// * **last path component** */path*
///
/// e.g. "https://token.build.account.gov.uk/token"
///
/// - SeeAlso: ``token(endPoint:stub:statusCode)`` on how to provide a stub token for a token request
class MockTokenURLProtocol: URLProtocol {
    
    enum InvalidURLError: Error, LocalizedError {
        case notTokenURL(url: URL)
      
      var errorDescription: String? {
          switch self {
          case .notTokenURL(let url):
              return "The token URL is expected to have a host 'token.account.gov.uk' and a last path component of 'token'. " +
                "Got a host '\(String(describing: url.host))' and a last path '\(url.lastPathComponent)' instead. Use URL(string: \"https://token.build.account.gov.uk/token\""
          }
      }
    }

    /// - Parameters:
    ///   - endPoint: the URL of the token end point for which you will be making a token request at.
    ///   - stub: a set of claims that you want to return in the body of the response for the given endPoint.
    public static func token(endPoint url: URL, claim: Claim = Claim.make(), stub claims: Claims, statusCode: Int = 200) throws {
        let token = try claim.token(claims).data(using: .utf8)!
        try stub(endPoint: url, token: token, statusCode: statusCode)
    }
    
    public static func token(endPoint url: URL, stub error: OIDError, statusCode: Int = 400) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(error)
        try stub(endPoint: url, token: data, statusCode: statusCode)
    }

    public static func error(endPoint url: URL, error: any Error) throws {
        errors[url] = error
    }

    /// Stubs a response for the given endPoint
    /// Calling this function with the same url, will replace any previous token for that url.
    ///
    /// Should you wish to add mutliple stubs for a token request, you can differentiate betwen each token request by adding a query to each one that
    /// is expected to provide a different token.
    ///
    /// e.g.
    ///     https://token.build.account.gov.uk/token?u=1
    ///     https://token.build.account.gov.uk/token?u=2
    ///
    /// Where "u" stands for "unique" and the value is unique across the set of token requests.
    ///
    /// - Parameters:
    ///   - endPoint: the URL of the token end point for which you will be making a token request at.
    ///   - token: an id token in the format of
    ///   ```
    ///    {
    ///        "access_token": [any],
    ///        "refresh_token": [any],
    ///        "id_token": [JWT value],
    ///        "token_type": "token",
    ///        "expires_in": 180
    ///    }
    ///    ```
    /// - SeeAlso: ``token(endPoint:stub:statusCode:)`` on how to add a stub using a set of claims
    /// - SeeAlso: ``Claim.make().token()`` on how to make a token in the expected format
    public static func stub(endPoint url: URL, token data: Data, statusCode: Int) throws {
        guard isTokenURL(url) else {
            throw InvalidURLError.notTokenURL(url: url)
        }
        
        guard let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        else { return }
        
        mockResponses[url] = (data, response)
    }

    private static var mockResponses: [URL: (Data, HTTPURLResponse)] = [:]
    private static var errors: [URL: any Error] = [:]

    private class func isTokenURL(_ url: URL) -> Bool {
        return url.host == "token.build.account.gov.uk" && url.lastPathComponent == "token"
    }
    override class func canInit(with task: URLSessionTask) -> Bool {
        guard let url = task.originalRequest?.url else {
            return false
        }
        return self.isTokenURL(url)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else {
            return false
        }
        return self.isTokenURL(url)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
        
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let (data, response) = Self.mockResponses[url] {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = Self.errors[url] {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}
// swiftlint:enable type_name
