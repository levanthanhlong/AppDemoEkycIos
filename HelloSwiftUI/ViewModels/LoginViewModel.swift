//
//  LoginViewModel.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 5/1/26.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var username = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var token: String?
    
    private let appState: AppState

    init(appState: AppState) {
          self.appState = appState
    }
    
    func generateClientTransactionId() -> String {
        // yyyyMMddHHmmss → 14 ký tự
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMddHHmmss"

        let timestamp = formatter.string(from: Date())

        // Random 5 chữ số (10000–99999)
        let randomPart = Int.random(in: 10000...99999)

        return "\(timestamp)_\(randomPart)" // tổng 20 ký tự
    }

    
    func login() {
        errorMessage = nil
        isLoading = true

        Task {
            do {
                let data = try await ApiServices.shared.login(
                    username: username,
                    password: password
                )
                DataUtils.TOKEN_CA = data.token
                print("✅ Login success:", data.user.username)
                do {
                    let sessionId = try await ApiServices.shared.initEkycSession(
                        clientTransactionId: generateClientTransactionId()
                    )
                    DataUtils.SESSION_CA = sessionId
                    print("SESSION_CA:", sessionId)

                } catch {
                    print("❌ Init EKYC error:", error.localizedDescription)
                }
                appState.loginSuccess(token: data.token)

            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
