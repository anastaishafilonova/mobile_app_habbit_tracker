import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = FriendsViewModel()
    @State private var showAddFriend = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Spacer()
                        Text("Друзья")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        if vm.isLoading {
                            ProgressView().tint(.white)
                        }
                    }
                    .padding(.top, 8)

                    Picker("", selection: $vm.tab) {
                        ForEach(FriendsViewModel.Tab.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)

                    SearchField(text: $vm.searchText)

                    if let err = vm.errorText {
                        Text(err)
                            .foregroundColor(.red.opacity(0.9))
                            .font(.system(size: 13))
                    }

                    switch vm.tab {
                    case .friends:
                        FriendsList(items: vm.filteredFriends, myId: vm.myId)
                    case .incoming:
                        IncomingList(items: vm.filteredIncoming) { id in
                            Task { await vm.accept(id) }
                        } onReject: { id in
                            Task { await vm.reject(id) }
                        }
                    case .outgoing:
                        OutgoingList(items: vm.filteredOutgoing)
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
        .task(id: session.currentUser?.id) {
            guard let me = session.currentUser?.id, let token = session.token else { return }
            vm.configure(myId: me, token: token)
            await vm.loadUsersViaYourService()
            await vm.reloadAll()
        }
        .sheet(isPresented: $showAddFriend) {
            if let me = session.currentUser?.id {
                let confirmed = Set(vm.friends.compactMap { vm.otherUser(for: $0)?.id })
                let incoming = Set(vm.incoming.map { $0.requester.id })
                let outgoing = Set(vm.outgoing.map { $0.addressee.id })
                let blocked = confirmed.union(incoming).union(outgoing)

                AddFriendView(
                    allUsers: vm.allUsers,
                    existingFriendIds: blocked,
                    currentUserId: me
                ) { user in
                    Task { await vm.sendFriendRequest(to: user.id) }
                }
            } else {
                Text("Загрузка…").preferredColorScheme(.dark)
            }
        }
        .preferredColorScheme(.dark)
    }
}
