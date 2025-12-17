import Foundation

@MainActor
final class FriendsViewModel: ObservableObject {
    enum Tab: String, CaseIterable, Identifiable {
        case friends = "Друзья"
        case incoming = "Входящие заявки"
        case outgoing = "Исходящие заявки"
        var id: String { rawValue }
    }

    @Published var tab: Tab = .friends
    @Published var searchText: String = ""

    @Published private(set) var friends: [FriendDTO] = []
    @Published private(set) var incoming: [FriendDTO] = []
    @Published private(set) var outgoing: [FriendDTO] = []

    @Published var allUsers: [UserDTO] = []
    @Published var isLoading: Bool = false
    @Published var errorText: String?

    private(set) var myId: UUID?
    private(set) var token: String?

    func configure(myId: UUID, token: String) {
        self.myId = myId
        self.token = token
    }

    func reloadAll() async {
        guard let token else { return }
        isLoading = true
        errorText = nil
        do {
            async let f = FriendsService.shared.friends(token: token)
            async let i = FriendsService.shared.incoming(token: token)
            async let o = FriendsService.shared.outgoing(token: token)
            let (friendsRes, incomingRes, outgoingRes) = try await (f, i, o)

            self.friends = friendsRes
            self.incoming = incomingRes
            self.outgoing = outgoingRes
        } catch {
            self.errorText = "Ошибка загрузки друзей: \(error)"
        }
        isLoading = false
    }

    func loadUsersViaYourService() async {
        guard let token else { return }
        do {
            self.allUsers = try await UserService.shared.getAllUsers(token: token)
        } catch {
            self.errorText = "Ошибка загрузки пользователей: \(error)"
        }
    }

    func sendFriendRequest(to addresseeId: UUID) async {
        guard let token else { return }
        do {
            _ = try await FriendsService.shared.sendRequest(addresseeId: addresseeId, token: token)
            await reloadAll()
        } catch {
            errorText = "Не удалось отправить заявку: \(error)"
        }
    }

    func accept(_ friendshipId: UUID) async {
        guard let token else { return }
        do {
            try await FriendsService.shared.accept(friendshipId: friendshipId, token: token)
            await reloadAll()
        } catch {
            errorText = "Не удалось принять: \(error)"
        }
    }

    func reject(_ friendshipId: UUID) async {
        guard let token else { return }
        do {
            try await FriendsService.shared.reject(friendshipId: friendshipId, token: token)
            await reloadAll()
        } catch {
            errorText = "Не удалось отклонить: \(error)"
        }
    }


    func otherUser(for item: FriendDTO) -> ApiUserDTO? {
        guard let myId else { return nil }
        if item.requester.id == myId { return item.addressee }
        if item.addressee.id == myId { return item.requester }
        return item.addressee
    }

    private func matchesSearch(_ user: ApiUserDTO) -> Bool {
        let q = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return true }
        return user.username.lowercased().contains(q) || user.email.lowercased().contains(q)
    }

    var filteredFriends: [FriendDTO] {
        friends.filter { item in
            guard let u = otherUser(for: item) else { return true }
            return matchesSearch(u)
        }
    }

    var filteredIncoming: [FriendDTO] {
        incoming.filter { item in
            matchesSearch(item.requester)
        }
    }

    var filteredOutgoing: [FriendDTO] {
        outgoing.filter { item in
            matchesSearch(item.addressee)
        }
    }
}
