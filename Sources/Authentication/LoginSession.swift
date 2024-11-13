import UIKit

@MainActor
public protocol LoginSession {
    func performLoginFlow(configuration: LoginSessionConfiguration) async throws -> TokenResponse
    func finalise(redirectURL url: URL) throws
}
