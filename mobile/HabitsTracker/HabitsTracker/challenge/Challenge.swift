import Foundation

enum ChallengeStatus: String, Codable {
    case active = "ACTIVE"
    case completed = "COMPLETED"
}

struct Challenge: Identifiable {
    var id: UUID
    var title: String
    var description: String?
    var participants: [ParticipantDTO]
    var totalDays: Int
    var status: ChallengeStatus
    var createdBy: UUID
    var icon: String
    
    func status(for userId: UUID?) -> ChallengeStatus {
        guard
            let userId,
            let me = participants.first(where: { $0.id == userId })
        else {
            return status
        }
        return me.status
    }

    func progress(for userId: UUID?) -> Double {
        guard let userId else { return 0 }

        let p = participants.first { $0.id == userId }
        let days = p?.progressDays ?? 0

        return totalDays == 0 ? 0 : Double(days) / Double(totalDays)
    }

    func participantProgress(_ p: ParticipantDTO) -> Double {
        Double(p.progressDays ?? 0) / Double(totalDays)
    }

    var subtitle: String {
        "Цель: \(totalDays) дней"
    }
}

extension Challenge {
    init(from dto: ChallengeDTO) {
        self.id = dto.id
        self.title = dto.title
        self.description = dto.description
        self.totalDays = dto.totalDays
        self.status = dto.status
        self.participants = dto.participants ?? []
        self.createdBy = dto.createdBy
        self.icon = dto.icon
    }
}
