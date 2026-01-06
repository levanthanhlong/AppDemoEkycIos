//
//  LoginView.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 5/1/26.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject private var vm: LoginViewModel

     init(appState: AppState) {
         _vm = StateObject(wrappedValue: LoginViewModel(appState: appState))
     }
    
    
    private enum FocusField {
        case username
        case password
    }
    
    @FocusState private var focusField: FocusField?


    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            VStack(spacing: 8) {
                Text("Welcome Back 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Đăng nhập để tiếp tục")
                    .foregroundColor(.gray)
            }

            VStack(spacing: 16) {

                TextField("Tên đăng nhập", text: $vm.username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                    .focused($focusField, equals: .username)

                HStack {
                    if vm.showPassword {
                        TextField("Mật khẩu", text: $vm.password).focused($focusField, equals: .password)
                    } else {
                        SecureField("Mật khẩu", text: $vm.password).focused($focusField, equals: .password)
                    }

                    Button {
                        vm.showPassword.toggle()
                    } label: {
                        Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            Button {
                vm.login()
            } label: {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Đăng nhập")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(14)
            .disabled(vm.isLoading)

            Spacer()
        }
        .padding()
        .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        focusField = .username
                    }
                }
    }
}

