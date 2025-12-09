import Foundation
import SwiftUI

final class FriendsStore {
    static let shared = FriendsStore()
    private init() {}

    private func key(for userId: UUID) -> String {
        "local_friends.\(userId.uuidString)"
    }

    func save(_ friends: [UserDTO], for userId: UUID) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(friends) else { return }
        UserDefaults.standard.set(data, forKey: key(for: userId))
    }

    func load(for userId: UUID) -> [UserDTO] {
        guard let data = UserDefaults.standard.data(forKey: key(for: userId)) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([UserDTO].self, from: data)) ?? []
    }
}
