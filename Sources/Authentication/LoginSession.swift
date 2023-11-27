import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func authenticate(configuration: LoginSessionConfiguration) throws -> TokenResponse
    func finalise(redirectURL: URL)
    func cancel()
}
