import Foundation
import Networking

public protocol UserServicing {
    func fetchUserInfo() async throws -> UserInfo
}

public final class UserService: UserServicing {
    let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchUserInfo() async throws  -> UserInfo {
        let data = try await client.makeRequest(.init(url: .userInfo))
        return try JSONDecoder().decode(UserInfo.self, from: data)
    }
}
