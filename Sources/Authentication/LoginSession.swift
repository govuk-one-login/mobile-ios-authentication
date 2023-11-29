import UIKit
import AppAuthCore

public protocol LoginSession {
    init(window: UIWindow)
    func present(configuration: LoginSessionConfiguration)
    func finalise(redirectURL url: URL) async throws -> TokenResponse
}
