import Foundation
import SwiftUI

struct TemplateLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var session: SessionViewModel

    @State private var templates: [ChallengeTemplateDTO] = []
    @State private var isLoading = true
    @State private var error: String? = nil

    let onSelect: (ChallengeTemplateDTO) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let error {
                    VStack(spacing: 12) {
                        Text("Ошибка")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text(error)
                            .foregroundColor(.white.opacity(0.7))
                        Button("Закрыть") { dismiss() }
                            .foregroundColor(.white)
                            .padding(.top, 16)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(templates) { template in
                                TemplateRow(template: template) {
                                    onSelect(template)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Шаблоны")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(.white)
                }
            }
            .task {
                await loadTemplates()
            }
        }
    }

    private func loadTemplates() async {
        guard let token = session.token else {
            error = "Необходима авторизация"
            return
        }

        do {
            templates = try await ChallengeService.shared.getTemplates(token: token)
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}

  struct TemplateRow: View {
      let template: ChallengeTemplateDTO
      let onTap: () -> Void

      var body: some View {
          Button(action: onTap) {
              HStack(spacing: 12) {
                  RoundedRectangle(cornerRadius: 12)
                      .fill(Color.white.opacity(0.1))
                      .frame(width: 52, height: 52)
                      .overlay(
                          Image(systemName: "doc.text")
                              .foregroundColor(.white)
                              .font(.system(size: 22))
                      )

                  VStack(alignment: .leading, spacing: 6) {
                      Text(template.title)
                          .foregroundColor(.white)
                          .font(.system(size: 16, weight: .semibold))

                      Text(template.description ?? "")
                          .foregroundColor(.white.opacity(0.7))
                          .font(.system(size: 13))
                          .lineLimit(2)
                  }

                  Spacer()
              }
              .padding(12)
              .background(
                  RoundedRectangle(cornerRadius: 18)
                      .fill(Color.white.opacity(0.06))
              )
          }
      }
  }
