import SwiftUI

struct OnboardingView: View {
    var onStart: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Присоединяйтесь\nк игре привычек")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.90, green: 0.88, blue: 1.0))
                        .multilineTextAlignment(.leading)

                    Text("Объединяйтесь с друзьями в задачах и привычках, превращая их в весёлую игру.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.73, green: 0.70, blue: 0.98))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: {
                    onStart?()
                }) {
                    HStack {
                        Text("Начать")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    Capsule()
                        .fill(Color(red: 0.53, green: 0.26, blue: 0.99))
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView()
}
