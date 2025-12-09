import Foundation

final class AuthService {
    static let shared = AuthService()

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = LoginRequest(login: email, password: password)

        return try await APIClient.shared.request(
            "/auth/login",
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        )
    }

    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let body = RegisterRequest(username: name, email: email, password: password)

        return try await APIClient.shared.request(
            "/auth/register",
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        )
    }
}

