//
//  HelloSwiftUIApp.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 17/12/25.
//

import SwiftUI

@main
struct HelloSwiftUIApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
                    NavigationStack {
                        if appState.isLoggedIn {
                            ContentView()
                        } else {
                            LoginView(appState: appState)
                        }
                    }
                    .environmentObject(appState)
        }
    }
}
