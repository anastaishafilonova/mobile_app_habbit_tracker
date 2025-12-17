import Foundation

struct ChallengeTemplateDTO: Decodable, Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let frequency: String
    let photo: String?
}
