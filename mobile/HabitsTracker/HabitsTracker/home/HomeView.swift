import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var viewModel = HomeViewModel()
    @State private var isPresentingNewChallenge = false

    enum ChallengeFilter: String, CaseIterable {
        case all = "Все"
        case active = "Активные"
        case completed = "Завершённые"

        var title: String { rawValue }

        var sectionTitle: String {
            switch self {
            case .all: return "Все челленджи"
            case .active: return "Активные челленджи"
            case .completed: return "Завершённые челленджи"
            }
        }
    }

    @State private var selectedFilter: ChallengeFilter = .all
    

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.isLoading && viewModel.challenges.isEmpty {
                ProgressView()
                    .tint(.white)
            } else {
                content
            }

            VStack {
                Spacer()
                Button(action: {
                    isPresentingNewChallenge = true
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.73, green: 0.47, blue: 1.0),
                                        Color(red: 0.52, green: 0.27, blue: 0.99)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)

                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresentingNewChallenge) {
            NewChallengeView {
                Task { await load() }
            }
            .environmentObject(session)
        }
        .task {
            await load()
        }
    }


    @ViewBuilder
    private var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Spacer()
                    Text("Мои челленджи")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    Spacer()
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }

                if !viewModel.challenges.isEmpty {
                    WeeklyProgressCard(
                        progress: viewModel.weeklyProgress,
                        completed: viewModel.completedCount,
                        total: viewModel.totalCount
                    )

                    filterChips

                    Text(selectedFilter.sectionTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 4)

                    VStack(spacing: 16) {
                        ForEach(filteredIndices, id: \.self) { index in
                            NavigationLink {
                                ChallengeDetailView(
                                    challenge: $viewModel.challenges[index],
                                    onDeleted: { deletedId in
                                        viewModel.removeChallenge(id: deletedId)
                                    }
                                )
                            } label: {
                                ChallengeRow(challenge: viewModel.challenges[index])
                            }
                            .buttonStyle(.plain)
                        }

                        if filteredIndices.isEmpty {
                            Text(emptyStateText)
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 15))
                                .padding(.top, 8)
                        }
                    }
                } else if viewModel.errorMessage == nil {
                    Text("У вас пока нет активных челленджей")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 80)
        }
    }

    private var filteredIndices: [Int] {
        viewModel.challenges.indices.filter { index in
            let ch = viewModel.challenges[index]
            let myStatus: ChallengeStatus = ch.status(for: session.currentUser?.id)
            switch selectedFilter {
            case .all:
                return true
            case .active:
                return myStatus == .active
            case .completed:
                return myStatus == .completed
            }
        }
    }

    private var emptyStateText: String {
        switch selectedFilter {
        case .all: return "У вас пока нет челленджей"
        case .active: return "Нет активных челленджей"
        case .completed: return "Вы ещё не завершили ни одного челленджа"
        }
    }


    private var filterChips: some View {
        HStack(spacing: 8) {
            ForEach(ChallengeFilter.allCases, id: \.self) { filter in
                Button {
                    withAnimation(.easeInOut) {
                        selectedFilter = filter
                    }
                } label: {
                    Text(filter.title)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if selectedFilter == filter {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.73, green: 0.47, blue: 1.0),
                                                    Color(red: 0.52, green: 0.27, blue: 0.99)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                } else {
                                    Capsule()
                                        .fill(Color.white.opacity(0.08))
                                }
                            }
                        )
                        .foregroundColor(selectedFilter == filter ? .white : .white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
    }


    private func load() async {
        guard let token = session.token else { return }
        await viewModel.loadChallenges(token: token)
    }
}


private struct WeeklyProgressCard: View {
    let progress: Double
    let completed: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Прогресс за неделю")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }

            ProgressBarView(value: progress)
                .frame(height: 10)
                .padding(.top, 4)

            Text("\(completed) из \(total) челленджей завершено")
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.8))
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.73, green: 0.47, blue: 1.0),
                    Color(red: 0.52, green: 0.27, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
    }
}

private struct ChallengeRow: View {
    let challenge: Challenge
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(statusText)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(statusColor)

                Text(challenge.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(challenge.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.8))

                ProgressBarView(value: challenge.progress(for: session.currentUser?.id))
                    .frame(height: 6)
                    .padding(.top, 4)
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 64, height: 64)

                Image(systemName: challenge.icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.11, green: 0.07, blue: 0.22))
        )
    }
    
    private var myStatus: ChallengeStatus {
        challenge.status(for: session.currentUser?.id)
    }

    private var statusText: String {
        switch myStatus {
        case .completed: return "Завершено"
        case .active: return "В процессе"
        }
    }

    private var statusColor: Color {
        switch myStatus {
        case .completed:
            return Color(red: 0.96, green: 0.74, blue: 0.95)
        case .active:
            return Color(red: 0.99, green: 0.96, blue: 0.62)
        }
    }
}
