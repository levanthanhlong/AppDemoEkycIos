//
//  AppState.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 5/1/26.
//

import SwiftUI

@MainActor
final class AppState: ObservableObject {

    @Published var isLoggedIn: Bool = !DataUtils.TOKEN_CA.isEmpty

    func loginSuccess(token: String) {
        DataUtils.TOKEN_CA = token
        isLoggedIn = true
    }

    func logout() {
        DataUtils.TOKEN_CA = ""
        isLoggedIn = false
    }
}
