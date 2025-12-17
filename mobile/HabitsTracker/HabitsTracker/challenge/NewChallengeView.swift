import SwiftUI


enum ChallengeDuration: Int, CaseIterable {
    case seven = 7
    case fourteen = 14
    case thirty = 30
    case fifty = 50
    case hundred = 100

    var title: String {
        switch self {
        case .seven: return "7 дней"
        case .fourteen: return "14 дней"
        case .thirty: return "30 дней"
        case .fifty: return "50 дней"
        case .hundred: return "100 дней"
        }
    }
}

let challengeIconOptions: [String] = [
    "flame.fill",
    "bolt.fill",
    "drop.fill",
    "leaf.fill",
    "heart.fill",
    "sun.max.fill",
    "moon.stars.fill",
    "clock.fill",
    "book.fill",
    "brain.head.profile",
    "figure.walk",
    "figure.run",
    "dumbbell.fill",
    "cup.and.saucer.fill",
    "bed.double.fill",
    "checkmark.seal.fill",
    "star.fill",
    "target",
    "list.bullet.clipboard",
    "medal.fill",
    "trophy.fill",
    "hands.clap.fill",
    "sparkles",
    "figure.yoga",
    "figure.cooldown"
]


struct NewChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: SessionViewModel

    var onCreated: () -> Void

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedDuration: ChallengeDuration = .seven

    @State private var friendSelections: [LocalFriendSelection] = []

    @State private var isCreating: Bool = false
    @State private var errorMessage: String?
    
    @State private var isChoosingTemplate = false
    @State private var selectedIconName: String = "flame.fill"

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        Text("Новый челлендж")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.98, blue: 0.71))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                        
                        Button {
                            isChoosingTemplate = true
                        } label: {
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                Text("Выбрать шаблон")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.08))
                            )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Название")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))

                            TextField("Название челленджа", text: $title)
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.06))
                                )
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Описание")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))

                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.06))
                                )
                                .foregroundColor(.white)
                                .overlay(
                                    Group {
                                        if description.isEmpty {
                                            Text("Расскажите о челлендже…")
                                                .font(.system(size: 15))
                                                .foregroundColor(Color.white.opacity(0.4))
                                                .padding(.horizontal, 18)
                                                .padding(.vertical, 14)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                )
                        }
                        
                        ChallengeIconPicker(selectedIconName: $selectedIconName)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Длительность")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(ChallengeDuration.allCases, id: \.self) { duration in
                                        DurationChip(
                                            title: duration.title,
                                            isSelected: duration == selectedDuration
                                        ) {
                                            selectedDuration = duration
                                        }
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Пригласить друзей")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.7))

                            if friendSelections.isEmpty {
                                Text("У вас пока нет друзей")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.top, 4)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach($friendSelections) { $item in
                                        LocalFriendRow(selection: $item)
                                    }
                                }
                            }
                        }
                        
                        if let error = errorMessage {
                            Text(error)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                        }

                        Button(action: createChallenge) {
                            ZStack {
                                if isCreating {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Создать челлендж")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.56, green: 0.30, blue: 1.0))
                            )
                        }
                        .padding(.top, 12)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || isCreating)
                        .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.6 : 1.0)

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.06))
                            )
                    }
                }
            }
            .sheet(isPresented: $isChoosingTemplate) {
                TemplateLibraryView { template in
                    applyTemplate(template)
                    isChoosingTemplate = false
                }
                .environmentObject(session)
            }
            .task {
                guard let me = session.currentUser?.id,
                      let token = session.token else { return }

                do {
                    let friendships = try await FriendsService.shared.friends(token: token)

                    let users: [UserDTO] = friendships.map { f in
                        let other = (f.requester.id == me) ? f.addressee : f.requester
                        return UserDTO(
                            id: other.id,
                            name: other.username,
                            email: other.email, 
                            avatarImage: other.avatarImage,
                            score: other.score
                        )
                    }

                    friendSelections = users.map { LocalFriendSelection(user: $0) }
                } catch {
                    errorMessage = "Не удалось загрузить друзей: \(error.localizedDescription)"
                }
            }

            .preferredColorScheme(.dark)
            .alert("Ошибка", isPresented: Binding(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Button("Ок", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Неизвестная ошибка")
            }
        }
    }

    private func createChallenge() {
        errorMessage = nil

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            errorMessage = "Введите название челленджа"
            return
        }

        guard let token = session.token else {
            errorMessage = "Необходима авторизация"
            return
        }

        isCreating = true

        Task {
            do {
                let now = Date()
                let days = selectedDuration.rawValue
                let end = Calendar.current.date(byAdding: .day, value: days, to: now) ?? now
                let selectedFriendIds = friendSelections
                    .filter { $0.isSelected }
                    .map { $0.user.id }

                let body = CreateChallengeRequest(
                    title: trimmedTitle,
                    description: trimmedDescription.isEmpty ? nil : trimmedDescription,
                    startTime: now,
                    endTime: end,
                    frequency: "DAILY",
                    aim: days,
                    pushOn: true,
                    templateId: nil,
                    opponentIds: selectedFriendIds,
                    icon: selectedIconName
                )

                _ = try await ChallengeService.shared.createChallenge(body, token: token)

                await MainActor.run {
                    isCreating = false
                    onCreated()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isCreating = false
                    errorMessage = (error as? APIError)?.localizedDescription
                        ?? error.localizedDescription
                }
            }
        }
    }
    
    private func applyTemplate(_ template: ChallengeTemplateDTO) {
        title = template.title
        description = template.description ?? ""
        selectedDuration = .seven
    }
}

struct LocalFriendSelection: Identifiable {
    var id: UUID { user.id }
    let user: UserDTO
    var isSelected: Bool = false
}


private struct DurationChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : Color.white.opacity(0.8))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? Color(red: 0.73, green: 0.47, blue: 1.0)
                            : Color.clear
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                        )
                )
        }
    }
}

struct ChallengeIconPicker: View {
    @Binding var selectedIconName: String

    private let columns = [GridItem(.adaptive(minimum: 44))]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Иконка челленджа")
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 13))

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(challengeIconOptions, id: \.self) { icon in
                    Button {
                        selectedIconName = icon
                    } label: {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(selectedIconName == icon
                                          ? Color.purple.opacity(0.8)
                                          : Color.white.opacity(0.08))
                            )
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


struct LocalFriendRow: View {
    @Binding var selection: LocalFriendSelection

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(avatarPath: selection.user.avatarImage, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(selection.user.name)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))

                Text(selection.user.email)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 13))

                Text("Баллы: \(selection.user.score)")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 13))
            }

            Spacer()

            Button {
                selection.isSelected.toggle()
            } label: {
                Image(systemName: selection.isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selection.isSelected ? .green : .white.opacity(0.6))
                    .font(.system(size: 24))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.06))
        )
    }
}
