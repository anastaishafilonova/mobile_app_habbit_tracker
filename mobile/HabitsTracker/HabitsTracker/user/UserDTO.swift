import Foundation

struct UserDTO: Decodable, Identifiable, Encodable {
    let id: UUID
    let name: String
    let email: String
    let avatarImage: String?
    let score: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name = "username"
        case email
        case avatarImage
        case score
    }
}

