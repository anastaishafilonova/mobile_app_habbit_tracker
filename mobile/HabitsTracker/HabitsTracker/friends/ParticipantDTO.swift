import Foundation

struct ParticipantDTO: Codable, Identifiable {
    let id: UUID
    let username: String
    let email: String
    let avatarImage: String?
    let score: Int?
    let progressDays: Int?
    let status: ChallengeStatus
    let markedToday: Bool
}
