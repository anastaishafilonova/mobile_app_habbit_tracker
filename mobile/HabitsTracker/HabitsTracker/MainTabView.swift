import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Главная")
            }

            NavigationStack {
                FriendsView()
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("Друзья")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Профиль")
            }
        }
        .tint(Color(red: 0.70, green: 0.40, blue: 1.0))
    }
}


#Preview {
    MainTabView()
}
