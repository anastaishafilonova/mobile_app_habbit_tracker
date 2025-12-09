//import SwiftUI
//
//struct EditChallengeView: View {
//    @Binding var challenge: Challenge
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var isInvitingFriends: Bool = false
//
//    @State private var title: String
//    @State private var description: String
//    @State private var totalDaysText: String
//
//    init(challenge: Binding<Challenge>) {
//        _challenge = challenge
//        _title = State(initialValue: challenge.wrappedValue.title)
//        _description = State(initialValue: challenge.wrappedValue.description ?? "описания нет")
//        _totalDaysText = State(initialValue: String(challenge.wrappedValue.totalDays))
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.black.ignoresSafeArea()
//
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 18) {
//
//                        Text("Редактирование")
//                            .font(.system(size: 22, weight: .bold))
//                            .foregroundColor(.white)
//                            .padding(.bottom, 4)
//
//                        EditField(title: "Название", text: $title)
//
//                        EditField(title: "Описание", text: $description, isMultiline: true)
//
//                        EditField(title: "Длительность (дней)", text: $totalDaysText, keyboardType: .numberPad)
//                        
//                        // уже приглашённые друзья (если есть)
//                        if !challenge.invitedFriends.isEmpty {
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text("Приглашённые друзья")
//                                    .font(.system(size: 13))
//                                    .foregroundColor(Color.white.opacity(0.7))
//
//                                VStack(spacing: 8) {
//                                    ForEach(challenge.invitedFriends) { friend in
//                                        HStack(spacing: 12) {
//                                            Image(systemName: friend.avatarSystemName)
//                                                .font(.system(size: 26))
//                                                .foregroundColor(.white)
//                                                .frame(width: 36, height: 36)
//                                                .background(
//                                                    Circle().fill(Color.white.opacity(0.08))
//                                                )
//
//                                            VStack(alignment: .leading, spacing: 2) {
//                                                Text(friend.name)
//                                                    .font(.system(size: 15, weight: .semibold))
//                                                    .foregroundColor(.white)
//
//                                                Text(friend.handle)
//                                                    .font(.system(size: 13))
//                                                    .foregroundColor(Color.white.opacity(0.7))
//                                            }
//
//                                            Spacer()
//                                        }
//                                        .padding(10)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 18)
//                                                .fill(Color.white.opacity(0.05))
//                                        )
//                                    }
//                                }
//                            }
//                        }
//
//                        // кнопка "Пригласить друга"
//                        Button(action: { isInvitingFriends = true }) {
//                            HStack {
//                                Image(systemName: "person.badge.plus")
//                                Text("Пригласить друга")
//                            }
//                            .font(.system(size: 15, weight: .semibold))
//                            .foregroundColor(Color(red: 1.0, green: 0.53, blue: 0.78))
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                        }
//                        .padding(.top, 4)
//
//                        Spacer(minLength: 20)
//
//                        Button(action: save) {
//                            Text("Сохранить")
//                                .font(.system(size: 17, weight: .semibold))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity, minHeight: 52)
//                                .background(
//                                    Capsule()
//                                        .fill(Color(red: 0.56, green: 0.30, blue: 1.0))
//                                )
//                        }
//                        .padding(.top, 8)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 24)
//                }
//            }
//            .preferredColorScheme(.dark)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Отмена") {
//                        dismiss()
//                    }
//                    .foregroundColor(.white)
//                }
//            }
//            .sheet(isPresented: $isInvitingFriends) {
//                InviteFriendsView(
//                    alreadyInvited: challenge.invitedFriends
//                ) { newFriends in
//                    // добавляем только новых
//                    for friend in newFriends where !challenge.invitedFriends.contains(friend) {
//                        challenge.invitedFriends.append(friend)
//                    }
//                }
//            }
//        }
//    }
//
//    private func save() {
//        let newTotal = Int(totalDaysText) ?? challenge.totalDays
//        challenge.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
//        challenge.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
//        challenge.totalDays = max(newTotal, challenge.currentDays)  // не даём сделать меньше текущего прогресса
//        dismiss()
//    }
//}
//
//private struct EditField: View {
//    let title: String
//    @Binding var text: String
//    var isMultiline: Bool = false
//    var keyboardType: UIKeyboardType = .default
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text(title)
//                .font(.system(size: 13))
//                .foregroundColor(Color.white.opacity(0.7))
//
//            if isMultiline {
//                TextEditor(text: $text)
//                    .frame(minHeight: 90)
//                    .padding(12)
//                    .background(
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color.white.opacity(0.06))
//                    )
//                    .foregroundColor(.white)
//            } else {
//                TextField("", text: $text)
//                    .keyboardType(keyboardType)
//                    .padding(.horizontal, 14)
//                    .frame(height: 48)
//                    .background(
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color.white.opacity(0.06))
//                    )
//                    .foregroundColor(.white)
//            }
//        }
//    }
//}
