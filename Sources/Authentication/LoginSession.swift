import UIKit

public protocol LoginSession {
    init(window: UIWindow)
    var state: String? { get }
    func present(configuration: LoginSessionConfiguration)
    func finalise(callback: URL) async throws -> TokenResponse
    func cancel()
}
