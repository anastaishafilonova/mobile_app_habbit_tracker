import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @EnvironmentObject var session: SessionViewModel

    @Published var email = ""
    @Published var password = ""
    @Published var error = ""

    func login() async {
        do {
            let response = try await AuthService.shared.login(
                email: email,
                password: password
            )

            KeychainService.save(key: "jwt", value: response.token)

            session.isAuthenticated = true

        } catch {
            self.error = error.localizedDescription
        }
    }
}
