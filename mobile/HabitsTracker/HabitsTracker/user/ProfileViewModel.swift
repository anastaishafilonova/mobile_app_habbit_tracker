//
//  ProfileViewModel.swift
//  HabitsTracker
//
//  Created by anastaisha on 05.12.2025.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: UserDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadProfile(token: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let me = try await UserService.shared.getProfile(token: token)
            self.user = me
            self.user = me

        } catch {
            self.errorMessage = "Не удалось загрузить профиль"
        }

        isLoading = false
    }
}
