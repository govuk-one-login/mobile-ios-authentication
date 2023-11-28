import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func authenticate(configuration: LoginSessionConfiguration)
    func evaluateAuthentication() throws -> TokenResponse
    func finalise(redirectURL: URL)
}
