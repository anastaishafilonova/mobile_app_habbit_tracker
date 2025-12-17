import SwiftUI

enum AuthMode {
    case login
    case register
}

struct AuthView: View {
    @EnvironmentObject var session: SessionViewModel
    
    @State private var mode: AuthMode = .login
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(mode == .login ? "Добро пожаловать!" : "Создайте аккаунт")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.93, blue: 1.0))

                    Text("Начните свой путь к лучшей версии себя.")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 0.72, green: 0.70, blue: 0.95))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)

                VStack(spacing: 16) {
                    if mode == .register {
                            AuthTextField(
                                title: "Имя пользователя",
                                text: $username,
                                keyboardType: .default
                            )
                        }
                    
                    AuthTextField(
                        title: "Электронная почта",
                        text: $email,
                        keyboardType: .emailAddress
                    )

                    AuthSecureField(
                        title: "Пароль",
                        text: $password
                    )

                    if mode == .register {
                        AuthSecureField(
                            title: "Подтвердите пароль",
                            text: $confirmPassword
                        )
                    }
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: handlePrimaryAction) {
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(mode == .login ? "Войти" : "Зарегистрироваться")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .foregroundColor(.white)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.56, green: 0.30, blue: 1.0))
                    )
                }
                .disabled(!isPrimaryButtonEnabled || isLoading)
                .opacity(isPrimaryButtonEnabled ? 1.0 : 0.5)

                Spacer()

                HStack(spacing: 4) {
                    Text(mode == .login ? "У вас нет аккаунта?" : "У вас уже есть аккаунт?")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))

                    Button(action: toggleMode) {
                        Text(mode == .login ? "Зарегистрироваться" : "Войти")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.53, blue: 0.78))
                    }
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(.dark)
    }


    private var isPrimaryButtonEnabled: Bool {
        guard !email.isEmpty, !password.isEmpty else { return false }
        if mode == .register {
                return !username.isEmpty && !confirmPassword.isEmpty
            }
        return true
    }

    private func toggleMode() {
        withAnimation(.spring()) {
            mode = (mode == .login ? .register : .login)
            errorMessage = nil
        }
    }

    private func handlePrimaryAction() {
        errorMessage = nil

        guard email.contains("@") else {
            errorMessage = "Почта введена не корректно"
            return
        }

        guard password.count >= 8 else {
            errorMessage = "Пароль должен быть не короче 8 символов"
            return
        }

        if mode == .register && password != confirmPassword {
            errorMessage = "Пароли не совпадают"
            return
        }

        isLoading = true
        Task {
            do {
                let authResponse: AuthResponse

                switch mode {
                case .login:
                    authResponse = try await AuthService.shared.login(
                        email: email,
                        password: password
                    )
                case .register:
                    authResponse = try await AuthService.shared.register(
                        name: username,
                        email: email,
                        password: password
                    )
                }

                await MainActor.run {
                    session.setAuth(token: authResponse.token)
                    isLoading = false
                }
            } catch let apiError as APIError {
                await MainActor.run {
                    isLoading = false
                    errorMessage = apiError.localizedDescription
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка входа. Попробуйте ещё раз"
                }
            }
        }
    }

}


private struct AuthTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.7))

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.06))
                )
                .foregroundColor(.white)
        }
    }
}

private struct AuthSecureField: View {
    let title: String
    @Binding var text: String

    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.7))

            HStack {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.06))
            )
            .foregroundColor(.white)
        }
    }
}

#Preview {
    AuthView()
}
