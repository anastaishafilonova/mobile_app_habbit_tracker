import Foundation

struct CreateChallengeRequest: Encodable {
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date
    let frequency: String
    let aim: Int
    let pushOn: Bool
    let templateId: UUID?
    let opponentIds: [UUID]
    let icon: String
}

