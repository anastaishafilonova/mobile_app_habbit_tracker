import SwiftUI

enum AppConfig {
    static let baseURL = URL(string: "http://10.25.145.1:8086")!
}

struct AvatarView: View {
    let avatarPath: String?
    var size: CGFloat = 44
    var lineWidth: CGFloat = 1.5
    var showShadow: Bool = false

    var body: some View {
        Group {
            if let url = AvatarURLBuilder.makeURL(from: avatarPath, baseURL: AppConfig.baseURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.white.opacity(0.15), lineWidth: lineWidth)
        )
        .shadow(radius: showShadow ? 8 : 0)
        .accessibilityLabel("Avatar")
    }

    private var placeholder: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(size * 0.32)
            .background(Color.white.opacity(0.10))
    }
}

enum AvatarURLBuilder {
    static func makeURL(from path: String?, baseURL: URL) -> URL? {
        guard let path, !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }

        let trimmed = path.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return URL(string: trimmed)
        }
        return URL(string: trimmed, relativeTo: baseURL)
    }
}
