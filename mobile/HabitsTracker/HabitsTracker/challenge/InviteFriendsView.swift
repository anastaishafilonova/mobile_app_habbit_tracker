import SwiftUI

struct InviteFriendsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var challenge: Challenge

    let existingParticipants: [ParticipantDTO]
    let friends: [UserDTO]
    let onInvite: ([UUID]) -> Void

    @State private var selected: Set<UUID> = []
    @State private var search: String = ""

    var filteredFriends: [UserDTO] {
        let q = search.lowercased().trimmingCharacters(in: .whitespaces)

        return friends.filter { friend in
            !existingParticipants.contains(where: { $0.id == friend.id }) &&
            (q.isEmpty ||
             friend.name.lowercased().contains(q) ||
             friend.email.lowercased().contains(q))
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 16) {
                    SearchField(text: $search)

                    if filteredFriends.isEmpty {
                        Text("Нет друзей, доступных для приглашения")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.top, 40)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(filteredFriends) { user in
                                    HStack {
                                        ParticipantView(participant: user)

                                        Button {
                                            toggle(user.id)
                                        } label: {
                                            Image(systemName: selected.contains(user.id)
                                                  ? "checkmark.circle.fill"
                                                  : "circle")
                                                .font(.system(size: 26))
                                                .foregroundColor(selected.contains(user.id)
                                                                 ? .green
                                                                 : .white.opacity(0.7))
                                        }
                                    }
                                }
                            }
                            .padding(.top, 12)
                        }
                    }

                    Button(action: inviteSelected) {
                        Text("Пригласить (\(selected.count))")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Capsule()
                                    .fill(selected.isEmpty
                                          ? Color.purple.opacity(0.3)
                                          : Color.purple.opacity(0.8))
                            )
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .disabled(selected.isEmpty)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Выбор друзей")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func toggle(_ id: UUID) {
        if selected.contains(id) {
            selected.remove(id)
        } else {
            selected.insert(id)
        }
    }

    private func inviteSelected() {
        let ids = Array(selected)
        onInvite(ids)
        dismiss()
    }
}

struct ParticipantView: View {
    let participant: UserDTO

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: participant.avatarImage, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(participant.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(participant.email)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.7))
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.06))
        )
    }
}
