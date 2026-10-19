@testable import Authentication
import Foundation
import Testing

struct LoginSessionConfigurationTests {
    
    @Test
    func test_LoginSessionConfiguration() async {
        let sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://token.build.account.gov.uk/authorize")!,
                                                  tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!,
                                                  responseType: .code,
                                                  scopes: [.email],
                                                  clientID: "1234",
                                                  prefersEphemeralWebSession: true,
                                                  redirectURI: "https://mobile.build.account.gov.uk/redirect",
                                                  vectorsOfTrust: ["1"],
                                                  locale: .en,
                                                  persistentSessionId: "123456789")
        #expect(sut.authorizationEndpoint == URL(string: "https://token.build.account.gov.uk/authorize"))
        #expect(sut.tokenEndpoint == URL(string: "https://token.build.account.gov.uk/token"))
        #expect(sut.responseType == .code)
        #expect(sut.scopes == [.email])
        #expect(sut.clientID == "1234")
        #expect(sut.prefersEphemeralWebSession)
        #expect(sut.redirectURI == "https://mobile.build.account.gov.uk/redirect")
        #expect(sut.vectorsOfTrust == ["1"])
        #expect(sut.locale == .en)
        #expect(sut.persistentSessionId == "123456789")
    }
    
    @Test
    func test_defaultValues() async {
        let sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://token.build.account.gov.uk/authorize")!,
                                              tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!,
                                              clientID: "1234",
                                              redirectURI: "https://mobile.build.account.gov.uk/redirect")
        #expect(sut.responseType == .code)
        #expect(sut.scopes == [.openid, .email, .phone, .offline_access])
        #expect(sut.prefersEphemeralWebSession)
        #expect(sut.vectorsOfTrust == ["Cl.Cm.P0"])
        #expect(sut.vectorsOfTrust.description == "[\"Cl.Cm.P0\"]")
        #expect(sut.persistentSessionId == nil)
    }
    
    @Test
    func test_serviceConfiguration() async {
        let sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://token.build.account.gov.uk/authorize")!,
                                                  tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!,
                                                  responseType: .code,
                                                  scopes: [.email],
                                                  clientID: "1234",
                                                  prefersEphemeralWebSession: true,
                                                  redirectURI: "https://mobile.build.account.gov.uk/redirect",
                                                  vectorsOfTrust: ["1"],
                                                  locale: .en,
                                                  persistentSessionId: "123456789")

        #expect(sut.serviceConfiguration.authorizationEndpoint == URL(string: "https://token.build.account.gov.uk/authorize"))
        #expect(sut.serviceConfiguration.tokenEndpoint == URL(string: "https://token.build.account.gov.uk/token"))
    }
    
    @Test
    func test_authorizationRequest() async {
        let sut = await LoginSessionConfiguration(authorizationEndpoint: URL(string: "https://token.build.account.gov.uk/authorize")!,
                                                  tokenEndpoint: URL(string: "https://token.build.account.gov.uk/token")!,
                                                  responseType: .code,
                                                  scopes: [.email],
                                                  clientID: "1234",
                                                  prefersEphemeralWebSession: true,
                                                  redirectURI: "https://mobile.build.account.gov.uk/redirect",
                                                  vectorsOfTrust: ["1"],
                                                  locale: .en,
                                                  persistentSessionId: "123456789")

        #expect(sut.authorizationRequest.scope == "email")
        #expect(sut.authorizationRequest.redirectURL == URL(string: "https://mobile.build.account.gov.uk/redirect"))
        #expect(sut.authorizationRequest.responseType == "code")
        #expect(
            sut.authorizationRequest.additionalParameters ==
            [
                "vtr": "[\"1\"]",
                "ui_locales": "en",
                "govuk_signin_session_id": "123456789"
            ]
        )
    }
}
