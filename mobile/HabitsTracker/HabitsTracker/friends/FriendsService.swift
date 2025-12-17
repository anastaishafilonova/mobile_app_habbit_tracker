import Foundation

protocol FriendsServicing {
    func sendRequest(addresseeId: UUID, token: String) async throws -> UUID
    func accept(friendshipId: UUID, token: String) async throws
    func reject(friendshipId: UUID, token: String) async throws
    func incoming(token: String) async throws -> [FriendDTO]
    func outgoing(token: String) async throws -> [FriendDTO]
    func friends(token: String) async throws -> [FriendDTO]
}

final class FriendsService: FriendsServicing {
    static let shared = FriendsService()
    private init() {}

    private let client = APIClient.shared

    func sendRequest(addresseeId: UUID, token: String) async throws -> UUID {
        let endpoint = "/friends/request/\(addresseeId.uuidString)"
        do {
            struct IdWrap: Decodable { let id: UUID }

            let wrap = try await client.request(
                endpoint,
                method: "POST",
                authToken: token,
                responseType: IdWrap.self
            )
            return wrap.id
        }
    }

    func accept(friendshipId: UUID, token: String) async throws {
        try await client.requestVoid(
            "/friends/\(friendshipId.uuidString)/accept",
            method: "POST",
            authToken: token
        )
    }

    func reject(friendshipId: UUID, token: String) async throws {
        try await client.requestVoid(
            "/friends/\(friendshipId.uuidString)/reject",
            method: "POST",
            authToken: token
        )
    }

    func incoming(token: String) async throws -> [FriendDTO] {
        try await client.request(
            "/friends/incoming",
            authToken: token,
            responseType: [FriendDTO].self
        )
    }

    func outgoing(token: String) async throws -> [FriendDTO] {
        try await client.request(
            "/friends/outgoing",
            authToken: token,
            responseType: [FriendDTO].self
        )
    }

    func friends(token: String) async throws -> [FriendDTO] {
        try await client.request(
            "/friends",
            authToken: token,
            responseType: [FriendDTO].self
        )
    }
}

