import Foundation

enum FriendshipStatus: String, Codable {
    case PENDING, CONFIRMED, REJECTED
}

struct ApiUserDTO: Codable, Identifiable, Equatable {
    let id: UUID
    let email: String
    let username: String
    let score: Int
    let avatarImage: String?
}

struct FriendDTO: Codable, Identifiable, Equatable {
    let id: UUID
    let requester: ApiUserDTO
    let addressee: ApiUserDTO
    let status: FriendshipStatus
}
