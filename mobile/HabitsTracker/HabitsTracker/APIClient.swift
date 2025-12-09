import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case server(statusCode: Int, message: String?)
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный адрес сервера"
        case .server(_, let message):
            return message ?? "Ошибка сервера"
        case .decoding:
            return "Ошибка обработки ответа сервера"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private init() {}

    private let baseURL = "http://192.168.1.138:8086/api"

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        authToken: String? = nil,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601

            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let json = String(data: data, encoding: .utf8) {
            print("RAW JSON for \(endpoint):")
            print(json)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw APIError.server(statusCode: http.statusCode, message: message)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("DECODING ERROR for endpoint \(endpoint)")
            print(String(data: data, encoding: .utf8) ?? "no body")
            throw APIError.decoding
        }
    }
    
    func requestVoid(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        authToken: String? = nil
    ) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw APIError.server(statusCode: http.statusCode, message: message)
        }

    }
}

private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self._encode = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

