import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var viewModel = FriendsViewModel()
    @State private var showAddFriend = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Друзья")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    SearchField(text: $viewModel.searchText)

                    if viewModel.filteredFriends.isEmpty {
                        Text("Добавьте вашего первого друга")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 16)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.filteredFriends) { friend in
                                FriendRow(friend: friend)
                            }
                        }
                    }

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
            }

            VStack {
                Spacer()
                Button {
                    showAddFriend = true
                } label: {
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

                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            if let id = session.currentUser?.id {
                viewModel.configure(userId: id)
            }
        }
        .task {
            if let token = session.token {
                await viewModel.loadUsers(token: token)
            }
            viewModel.loadFriends()
        }
        .sheet(isPresented: $showAddFriend) {
            AddFriendView(
                allUsers: viewModel.allUsers,
                existingFriends: viewModel.friends,
                currentUserId: session.currentUser!.id
            ) { newFriend in
                viewModel.addFriend(newFriend)
            }
        }
        .preferredColorScheme(.dark)
    }
}

private struct FriendRow: View {
    let friend: UserDTO

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(friend.email)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.7))

                Text("Score: \(friend.score)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.8))
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
