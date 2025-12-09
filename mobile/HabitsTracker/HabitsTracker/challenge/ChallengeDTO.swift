import Foundation

struct ChallengeDTO: Decodable {
    let id: UUID
    let title: String
    let description: String?
    let status: ChallengeStatus
    let currentDays: Int
    let totalDays: Int
    let createdBy: UUID
    let participants: [ParticipantDTO]?
    let icon: String


    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case status
        case currentDays = "currentProgress"
        case totalDays = "aim"
        case createdBy
        case participants
        case icon
    }
}
