//
//  ToastView.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import SwiftUI

// MARK: - Toast View
struct ToastView: View {

    let message: String

    var body: some View {
        Text(message)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.8))
            )
            .shadow(radius: 4)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {

    @Binding var isShowing: Bool
    let message: String
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content

            if isShowing {
                VStack {
                    Spacer()
                    ToastView(message: message)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut, value: isShowing)
        .onChange(of: isShowing) { show in
            if show {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    isShowing = false
                }
            }
        }
    }
}

// MARK: - View Extension
extension View {

    func toast(
        isShowing: Binding<Bool>,
        message: String,
        duration: Double = 2
    ) -> some View {
        self.modifier(
            ToastModifier(
                isShowing: isShowing,
                message: message,
                duration: duration
            )
        )
    }
}
