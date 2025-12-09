import Foundation

final class ChallengeService {
    static let shared = ChallengeService()

    func getActiveChallenges(token: String) async throws -> [ChallengeDTO] {
        try await APIClient.shared.request(
            "/challenges/my",
            authToken: token,
            responseType: [ChallengeDTO].self
        )
    }

    func markProgress(challengeId: UUID, token: String) async throws -> ChallengeDTO {
        try await APIClient.shared.request(
            "/challenges/\(challengeId)/progress",
            method: "POST",
            authToken: token,
            responseType: ChallengeDTO.self
        )
    }
    
    func createChallenge(_ requestBody: CreateChallengeRequest, token: String) async throws -> ChallengeDTO {
        try await APIClient.shared.request(
            "/challenges/create",
            method: "POST",
            body: requestBody,
            authToken: token,
            responseType: ChallengeDTO.self
        )
    }
    
    func deleteChallenge(id: UUID, token: String) async throws {
        try await APIClient.shared.requestVoid(
            "/challenges/\(id)",
            method: "DELETE",
            authToken: token
        )
    }
    
    func inviteUsers(challengeId: UUID, ids: [UUID], token: String) async throws {
        let body = InviteUsersRequest(opponentIds: ids)
        try await APIClient.shared.requestVoid(
            "/challenges/\(challengeId)/invite",
            method: "POST",
            body: body,
            authToken: token
        )
    }
    
    func getTemplates(token: String) async throws -> [ChallengeTemplateDTO] {
        try await APIClient.shared.request(
            "/challenges/library",
            method: "GET",
            authToken: token,
            responseType: [ChallengeTemplateDTO].self
        )
    }
    
    func getChallenge(id: UUID, token: String) async throws -> ChallengeDTO {
        try await APIClient.shared.request(
            "/challenges/get/\(id)",
            method: "GET",
            authToken: token,
            responseType: ChallengeDTO.self
        )
    }

}
