import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    func present(configuration: LoginSessionConfiguration)
    func finalise(callback: URL) async throws -> TokenResponse
    func cancel()
}

