import Foundation

struct InviteUsersRequest: Encodable {
    let opponentIds: [UUID]
}
