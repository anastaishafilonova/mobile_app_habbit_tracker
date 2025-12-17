import SwiftUI

struct AddFriendView: View {
    let allUsers: [UserDTO]
    let existingFriendIds: Set<UUID>
    let currentUserId: UUID
    let onSelect: (UserDTO) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    var candidates: [UserDTO] {
        allUsers.filter { u in
            u.id != currentUserId && !existingFriendIds.contains(u.id)
        }
    }

    var filtered: [UserDTO] {
        let q = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return candidates }
        return candidates.filter {
            $0.name.lowercased().contains(q) || $0.email.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    SearchField(text: $searchText)

                    if filtered.isEmpty {
                        Text("Пользователи не найдены")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 12)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(filtered) { user in
                                    AddFriendRow(user: user) {
                                        onSelect(user)
                                        dismiss()
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Добавить друга")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

struct AddFriendRow: View {
    let user: UserDTO
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: user.avatarImage, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .foregroundColor(.white)
                Text(user.email)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Button(action: onAdd) {
                Text("Добавить")
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.purple))
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
    }
}
