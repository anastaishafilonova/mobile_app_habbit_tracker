import Foundation

final class UserService {
    static let shared = UserService()

    func getProfile(token: String) async throws -> UserDTO {
        return try await APIClient.shared.request(
            "/users/me",
            authToken: token,
            responseType: UserDTO.self
        )
    }
    
    func getUser(id: UUID, token: String) async throws -> ParticipantDTO {
        try await APIClient.shared.request(
            "/users/\(id)",
            authToken: token,
            responseType: ParticipantDTO.self
        )
    }
    
    func getAllUsers(token: String) async throws -> [UserDTO] {
        try await APIClient.shared.request(
            "/users/all",
            authToken: token,
            responseType: [UserDTO].self
        )
    }
    
    private let baseURL = URL(string: "http://10.25.145.1:8086/api")
    func uploadAvatar(imageData: Data, token: String) async throws -> UserDTO {
        let url = baseURL!.appending(path: "users/me/avatar")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var body = Data()

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"avatar.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NSError(domain: "UploadAvatar", code: status, userInfo: [
                NSLocalizedDescriptionKey: "Ошибка загрузки аватарки (код \(status))"
            ])
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(UserDTO.self, from: data)
    }

}


private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
