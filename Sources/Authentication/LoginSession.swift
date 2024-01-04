import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func performLoginFlow(configuration: LoginSessionConfiguration) async throws -> TokenResponse
    func finalise(redirectURL url: URL) throws
}
