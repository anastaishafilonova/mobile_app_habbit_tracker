import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var token: String? = nil
    @Published var currentUser: UserDTO? = nil

    init() {
        restoreSession()
    }

    func setAuth(token: String) {
        self.token = token
        self.isAuthenticated = true

        Task {
            await loadCurrentUser()
            KeychainService.save(key: "jwt_token.\(currentUser!.id)", value: token)
        }
    }

    func logout() {
        token = nil
        currentUser = nil
        isAuthenticated = false
        KeychainService.delete(key: "jwt_token.\(currentUser!.id)")
    }

    private func restoreSession() {
        if let stored = KeychainService.get(key: "jwt_token.\(String(describing: currentUser?.id))") {
            self.token = stored
            self.isAuthenticated = true

            Task {
                await loadCurrentUser()
            }
        }
    }

    func loadCurrentUser() async {
        guard let token = token else { return }
        do {
            let user = try await UserService.shared.getProfile(token: token)
            self.currentUser = user
        } catch {
            print("Failed to load current user:", error)
        }
    }
}
