import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var completedCount: Int {
        challenges.filter { $0.status == .completed }.count
    }

    var totalCount: Int {
        challenges.count
    }

    var weeklyProgress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    func loadChallenges(token: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let dtos = try await ChallengeService.shared.getActiveChallenges(token: token)
            self.challenges = dtos.map(Challenge.init(from:))
        } catch let apiError as APIError {
            self.errorMessage = apiError.localizedDescription
        } catch {
            self.errorMessage = "Не удалось загрузить челленджи"
        }

        isLoading = false
    }
    
    func removeChallenge(id: UUID) {
        challenges.removeAll { $0.id == id }
    }
}
