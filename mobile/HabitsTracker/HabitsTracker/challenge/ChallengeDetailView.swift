import SwiftUI

// Можно вынести в отдельный файл с цветами, но пока оставлю тут
extension Color {
    static let appBackground = Color(red: 8/255, green: 7/255, blue: 20/255)
    static let cardBackground = Color(red: 26/255, green: 22/255, blue: 48/255)
    static let primaryPurple  = Color(red: 137/255, green: 90/255, blue: 255/255)
    static let secondaryPurple = Color(red: 99/255, green: 72/255, blue: 214/255)
    static let softYellow = Color(red: 1.0, green: 0.93, blue: 0.6)
    static let green = Color(red: 185/255, green: 234/255, blue: 128/255)
}

struct ChallengeDetailView: View {
    @Binding var challenge: Challenge

    @EnvironmentObject var session: SessionViewModel
    @Environment(\.dismiss) private var dismiss

    var onDeleted: (UUID) -> Void

    @State private var isInvitingFriends = false
    @State private var isDeleting = false
    @State private var errorMessage: String?

    @State private var participants: [ParticipantDTO] = []
    
    private var myStatus: ChallengeStatus {
        challenge.status(for: session.currentUser?.id)
    }
    
    private var currParticipant: ParticipantDTO {
        challenge.participants.first { $0.id == session.currentUser!.id }!
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.appBackground, Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    headerCard

                    progressCard

                    participantsBlock

                    primaryActionButton
                    
                    if challenge.createdBy == session.currentUser?.id {
                        deleteButton
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .onAppear { participants = challenge.participants }
        .sheet(isPresented: $isInvitingFriends) {
            InviteFriendsView(
                challenge: $challenge,
                existingParticipants: participants,
                friends: FriendsStore.shared.load(for: session.currentUser!.id),
                onInvite: { ids in
                    Task {
                        await inviteUsers(ids)
                        await reloadChallenge()
                    }
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Челлендж")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryPurple)
                }
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(myStatus == .active ? "АКТИВНЫЙ ЧЕЛЛЕНДЖ" : "ЗАВЕРШЁННЫЙ ЧЕЛЛЕНДЖ")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(challenge.status == .active
                                 ? .softYellow.opacity(0.9)
                                 : .white.opacity(0.6))
                .textCase(.uppercase)

            Text(challenge.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(challenge.description ?? "Описания нет")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))

            Text("Цель: \(challenge.totalDays) дней")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.cardBackground)
        )
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ваш прогресс")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            if let me = participants.first(where: { $0.id == session.currentUser?.id }) {
                Text("\(me.progressDays ?? 0)/\(challenge.totalDays) дней")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text("Каждый день ты ближе к цели ✨")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            } else {
                Text("Вы ещё не отмечали выполнение")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }

            ProgressBarView(value: challenge.progress(for: session.currentUser?.id))
                .frame(height: 10)
                .clipShape(Capsule())
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [.secondaryPurple, .primaryPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.28)
            .background(Color.cardBackground)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var participantsBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Участники")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                if challenge.createdBy == session.currentUser?.id {
                    Button {
                        isInvitingFriends = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Пригласить")
                        }
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .stroke(Color.primaryPurple, lineWidth: 1)
                                .background(
                                    Capsule().fill(Color.white.opacity(0.06))
                                )
                        )
                        .foregroundColor(.white)
                    }
                }
            }

            if participants.isEmpty {
                Text("Пока только вы в этом челлендже. Пригласите друзей!")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 4)
            } else {
                VStack(spacing: 10) {
                    if let currentId = session.currentUser?.id {
                        ForEach(participants.filter { $0.id != currentId }) { p in
                            ChallengeParticipantRow(
                                participant: p,
                                progress: challenge.participantProgress(p),
                                totalDays: challenge.totalDays,
                                isCurrentUser: false
                            )
                        }
                    }
                }
            }
        }
    }

    private var primaryActionButton: some View {
        if !currParticipant.markedToday {
            Button(action: markProgress) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Отметить выполнение")
                }
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [.primaryPurple, .secondaryPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(Capsule())
                )
                .foregroundColor(.white)
                .shadow(color: .primaryPurple.opacity(0.4), radius: 10, x: 0, y: 6)
            }
            .padding(.top, 4)
            .disabled(myStatus == .completed)
            .opacity(myStatus == .completed ? 0.5 : 1)
        } else {
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Челлендж выполнен")
                }
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [.green, .green],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(Capsule())
                )
                .foregroundColor(.white)
                .shadow(color: .softYellow.opacity(0.4), radius: 10, x: 0, y: 6)
            }
            .padding(.top, 4)
            .disabled(true)
            .opacity(0.9)
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            Task {
                await deleteChallenge()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "trash")
                Text("Удалить челлендж")
            }
            .font(.system(size: 14, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.14))
            )
            .foregroundColor(.red)
        }
        .padding(.top, 10)
    }
    

    private func markProgress() {
        guard let token = session.token else { return }

        Task {
            do {
                let updated = try await ChallengeService.shared.markProgress(
                    challengeId: challenge.id,
                    token: token
                )
                await MainActor.run {
                    withAnimation(.easeInOut) {
                        challenge = Challenge(from: updated)
                        participants = challenge.participants
                    }
                }
            } catch {
                errorMessage = "Не удалось отметить прогресс"
            }
        }
    }

    private func deleteChallenge() async {
        guard let token = session.token else { return }
        do {
            try await ChallengeService.shared.deleteChallenge(id: challenge.id, token: token)
            onDeleted(challenge.id)
            dismiss()
        } catch {
            errorMessage = "Не удалось удалить челлендж"
        }
    }

    private func inviteUsers(_ ids: [UUID]) async {
        guard let token = session.token else { return }
        do {
            try await ChallengeService.shared.inviteUsers(
                challengeId: challenge.id,
                ids: ids,
                token: token
            )
        } catch {
            errorMessage = "Не удалось пригласить участников"
        }
    }

    private func reloadChallenge() async {
        guard let token = session.token else { return }

        do {
            let updated = try await ChallengeService.shared.getChallenge(
                id: challenge.id,
                token: token
            )
            await MainActor.run {
                withAnimation(.easeInOut) {
                    challenge = Challenge(from: updated)
                    participants = challenge.participants
                }
            }
        } catch {
            print("Ошибка перезагрузки челленджа:", error)
        }
    }
}


struct ChallengeParticipantRow: View {
    let participant: ParticipantDTO
    let progress: Double
    let totalDays: Int
    let isCurrentUser: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCurrentUser ? Color.primaryPurple : Color.white.opacity(0.16))

                Text(String(participant.username.prefix(1)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(participant.username)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    if isCurrentUser {
                        Text("это вы")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(Color.primaryPurple.opacity(0.2))
                            )
                            .foregroundColor(.primaryPurple)
                    }
                }

                Text(participant.email)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                ProgressBarView(value: progress)
                    .frame(height: 6)
                    .clipShape(Capsule())

                Text("\(participant.progressDays ?? 0)/\(totalDays) дней")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.cardBackground)
        )
    }
}
