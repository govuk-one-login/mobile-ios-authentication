import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    var tokenResponse: TokenResponse? { get set }
    func present(configuration: LoginSessionConfiguration)
    func finalise(callback: URL) async throws -> TokenResponse
    func finalise(redirectURL: URL)
    func cancel()
}
