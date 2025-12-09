import Foundation

struct Friend: Identifiable, Equatable {
    let id: UUID
    let name: String
    let handle: String
    let avatarSystemName: String
}

enum MockFriends {
    static let all: [Friend] = [
        Friend(id: UUID(), name: "Александр Смит", handle: "@alex.smith", avatarSystemName: "person.circle"),
        Friend(id: UUID(), name: "Эмили Джонс",    handle: "@emily.jones", avatarSystemName: "person.circle.fill"),
        Friend(id: UUID(), name: "Дэвид Браун",    handle: "@david.brown", avatarSystemName: "person.circle")
    ]
}
