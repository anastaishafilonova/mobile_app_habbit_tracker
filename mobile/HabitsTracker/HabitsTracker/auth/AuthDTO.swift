import Foundation

struct LoginRequest: Encodable {
    let login: String
    let password: String
}

struct RegisterRequest: Encodable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponse: Decodable {
    let token: String
}
