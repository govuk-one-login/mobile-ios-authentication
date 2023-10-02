import Foundation

public struct UserInfo: Codable {
    let sub: String
    let phoneNumberVerified: Bool
    let phoneNumber: String?
    let emailVerified: Bool
    public let email: String
    
    enum CodingKeys: String, CodingKey {
        case sub = "sub"
        case phoneNumberVerified = "phone_number_verified"
        case phoneNumber = "phone_number"
        case emailVerified = "email_verified"
        case email = "email"
    }
}

