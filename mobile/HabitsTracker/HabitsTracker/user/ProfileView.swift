import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ProfileView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var localAvatarImage: UIImage?
    private let baseURL: URL = URL(string: "http://93.175.4.58:8086")!
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.user == nil {
                ProgressView()
                    .tint(.white)
            } else {
                content
            }
        }
        .task {
            await load()
        }
        .onChange(of: selectedPhoto) { newItem in
            Task {
                await handleSelectedPhoto(newItem)
            }
        }
        .refreshable {
            await load()
        }
    }
    
    
    private func handleSelectedPhoto(_ item: PhotosPickerItem?) async {
        guard let item,
              let token = session.token else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                guard let jpegData = image.jpegData(compressionQuality: 0.7) else { return }
                let maxBytes = 1_000_000
                let uploadData: Data
                if jpegData.count > maxBytes {
                    uploadData = image.jpegData(compressionQuality: 0.4) ?? jpegData
                } else {
                    uploadData = jpegData
                }
                await MainActor.run {
                    self.localAvatarImage = image
                }

                let updatedUser = try await UserService.shared.uploadAvatar(
                    imageData: data,
                    token: token
                )

                await MainActor.run {
                    viewModel.user = updatedUser
                    session.currentUser = updatedUser
                }
            }
        } catch {
            print("Ошибка выбора/загрузки аватарки:", error)
        }
    }

    
    private func load() async {
        guard let token = session.token else { return }
        await viewModel.loadProfile(token: token)
    }

    var content: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    HStack {
                        Spacer()
                        Text("Профиль")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 8)

                    VStack(spacing: 12) {
                        avatarView
                            .frame(width: 96, height: 96)

                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text("Изменить аватар")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(Color.purple.opacity(0.85))
                                )
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)

                        VStack(spacing: 4) {
                            Text(session.currentUser?.name ?? "Профиль")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)

                            Text(session.currentUser?.email ?? "email не загружен")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                    Text("Score: \(viewModel.user?.score ?? 0)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 12)

                    Text("НАСТРОЙКИ")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.71, green: 0.66, blue: 0.96))

                    VStack(spacing: 0) {
                        SettingsRow(
                            title: "Уведомления",
                            systemImage: "bell.fill",
                            tint: Color(red: 0.78, green: 0.60, blue: 1.00)
                        )

                        Divider().background(Color.white.opacity(0.08))

                        SettingsRow(
                            title: "Конфиденциальность",
                            systemImage: "shield.fill",
                            tint: Color(red: 1.00, green: 0.64, blue: 0.80)
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.13, green: 0.09, blue: 0.23))
                    )

                    Text("ПОДДЕРЖКА")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.71, green: 0.66, blue: 0.96))

                    VStack(spacing: 0) {
                        SettingsRow(
                            title: "Помощь и обратная связь",
                            systemImage: "questionmark.circle.fill",
                            tint: Color(red: 1.00, green: 0.96, blue: 0.68)
                        )

                        Divider().background(Color.white.opacity(0.08))

                        SettingsRow(
                            title: "Правила и условия",
                            systemImage: "doc.text.fill",
                            tint: Color(red: 0.69, green: 0.52, blue: 1.00)
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.13, green: 0.09, blue: 0.23))
                    )

                    Button(action: {
                        session.isAuthenticated = false
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.33, green: 0.07, blue: 0.10).opacity(0.9))
                                    .frame(width: 32, height: 32)

                                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 1.00, green: 0.43, blue: 0.40))
                            }

                            Text("Выйти")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 1.00, green: 0.43, blue: 0.40))

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(red: 0.18, green: 0.07, blue: 0.11))
                        )
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
                    print("avatarImage:", viewModel.user?.avatarImage as Any)
                }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    private var avatarView: some View {
        Group {
            if let img = localAvatarImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()

            } else if let url = makeAvatarURL(from: viewModel.user?.avatarImage) {

                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }

            } else {
                placeholderAvatar
            }
        }
        .frame(width: 96, height: 96)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 2)
        )
        .shadow(radius: 8)
    }

    private var placeholderAvatar: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(16)
            .background(Color.white.opacity(0.1))
    }
    
    private func makeAvatarURL(from path: String?) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }

        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            let url = URL(string: path)
            print("avatar URL:", url?.absoluteString ?? "nil")
            return url
        }

        let url = URL(string: path, relativeTo: baseURL)
        print("avatar URL:", url?.absoluteString ?? "nil")
        return url
    }
}

private struct SettingsRow: View {
    let title: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 18))
                .foregroundColor(tint)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
