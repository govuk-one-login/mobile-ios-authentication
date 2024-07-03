import Foundation
import UIKit

public enum AuthType {
    case none
    case face
    case finger
    case pass
}

public protocol LocalAuthService {
    func evaluateLocalAuth(navigationController: UINavigationController,
                           completion: @escaping (AuthType) -> Void)
}
