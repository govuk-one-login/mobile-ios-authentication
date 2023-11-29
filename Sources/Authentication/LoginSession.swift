import AppAuthCore
import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func present(configuration: LoginSessionConfiguration, service: OIDAuthState.Type)
    func finalise(redirectURL url: URL) async throws -> TokenResponse
}
