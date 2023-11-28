import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func authenticate(configuration: LoginSessionConfiguration)
    func finalise(redirectURL url: URL) async throws -> TokenResponse
}
