import Authentication
import UIKit

class MockLocalAuthService: LocalAuthService {
    var didCall_evaluateLocalAuth: Bool = false
    var localAuthValue: AuthType = .none
    
    func evaluateLocalAuth(navigationController: UINavigationController,
                           completion: @escaping (AuthType) -> Void) {
        didCall_evaluateLocalAuth = true
        completion(localAuthValue)
    }
}
