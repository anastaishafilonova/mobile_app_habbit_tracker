import SwiftUI

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published var allUsers: [UserDTO] = []
    @Published var friends: [UserDTO] = []
    @Published var searchText: String = ""

    private var userId: UUID?
    
    func configure(userId: UUID) {
        self.userId = userId
        loadFriends()
    }

    func loadUsers(token: String) async {
        do {
            self.allUsers = try await UserService.shared.getAllUsers(token: token)
        } catch {
            print("Failed to load users: \(error)")
        }
    }

    func loadFriends() {
        guard let id = userId else {
            return
        }
        friends = FriendsStore.shared.load(for: id)
    }

    func addFriend(_ user: UserDTO) {
        guard !friends.contains(where: { $0.id == user.id }) else { return }
        friends.append(user)
        FriendsStore.shared.save(friends, for: userId!)
    }

    var filteredFriends: [UserDTO] {
        let query = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return friends }
        return friends.filter {
            $0.name.lowercased().contains(query) ||
            $0.email.lowercased().contains(query)
        }
    }
}
