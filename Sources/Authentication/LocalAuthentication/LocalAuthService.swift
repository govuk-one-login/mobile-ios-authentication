import Foundation
import UIKit

public enum AuthType {
    case none
    case face
    case touch
    case passcode
}

public protocol LocalAuthService {
    func evaluateLocalAuth(navigationController: UINavigationController,
                           completion: @escaping (AuthType) -> Void)
}
