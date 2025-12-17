import SwiftUI

public struct FriendsList: View {
    let items: [FriendDTO]
    let myId: UUID?

    public var body: some View {
        if items.isEmpty {
            Text("Пока нет друзей")
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 10)
        } else {
            VStack(spacing: 10) {
                ForEach(items) { item in
                    FriendRowBackend(item: item, myId: myId)
                }
            }
        }
    }
}

struct IncomingList: View {
    let items: [FriendDTO]
    let onAccept: (UUID) -> Void
    let onReject: (UUID) -> Void

    var body: some View {
        if items.isEmpty {
            Text("Нет входящих заявок")
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 10)
        } else {
            VStack(spacing: 10) {
                ForEach(items) { item in
                    IncomingRow(item: item, onAccept: { onAccept(item.id) }, onReject: { onReject(item.id) })
                }
            }
        }
    }
}

struct OutgoingList: View {
    let items: [FriendDTO]

    var body: some View {
        if items.isEmpty {
            Text("Нет исходящих заявок")
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 10)
        } else {
            VStack(spacing: 10) {
                ForEach(items) { item in
                    OutgoingRow(item: item)
                }
            }
        }
    }
}

public struct FriendRowBackend: View {
    let item: FriendDTO
    let myId: UUID?

    private var other: ApiUserDTO {
        if let myId, item.requester.id == myId { return item.addressee }
        return item.requester.id == myId ? item.addressee : item.requester
    }

    public var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: other.avatarImage, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(other.username)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(other.email)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                Text("Баллы: \(other.score)")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.06)))
    }
}

struct IncomingRow: View {
    let item: FriendDTO
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: item.requester.avatarImage, size: 46)


            VStack(alignment: .leading, spacing: 4) {
                Text(item.requester.username)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(item.requester.email)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            VStack(spacing: 8) {
                Button("Отклонить", action: onReject)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.white.opacity(0.12)))

                Button("Принять", action: onAccept)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.purple))
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
    }
}

struct OutgoingRow: View {
    let item: FriendDTO

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: item.addressee.avatarImage, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.addressee.username)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(item.addressee.email)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                Text("Ожидает подтверждения")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 13))
            }

            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
    }
}
