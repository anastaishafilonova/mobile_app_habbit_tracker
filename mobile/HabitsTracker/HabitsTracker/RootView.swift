import SwiftUI

enum AppStep {
    case onboarding
    case auth
}

struct RootView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var step: AppStep = .onboarding

    var body: some View {
        if session.isAuthenticated {
            MainTabView()
        } else {
            switch step {
            case .onboarding:
                OnboardingView {
                    withAnimation {
                        step = .auth
                    }
                }
            case .auth:
                AuthView()
            }
        }
    }
}
