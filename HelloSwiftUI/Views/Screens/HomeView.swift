////
////  ProfileView.swift
////  HelloSwiftUI
////
////  Created by ThanhLe on 17/12/25.
////
import SwiftUI

struct HomeView: View {
    @State private var isStartingEkyc = true
    @State private var toastMessage = ""
    @State private var showToast = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Tiêu đề
                Text("Demo SDK")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 50)
                
                // Nút reset session
                PrimaryButton(title: "Reset Session") {
                    ApiServices.shared.getSessionKLP { result in
                        switch result {
                        case .success(let session_klp):
                            print("✅ Lấy Session KLP thành công")
                            print("Session :", session_klp)
                        case .failure(let error):
                            print("❌ Lấy session_klp thất bại", error.localizedDescription)
                        }
                    }
                    if (AppConst.IS_USE_CMC_GATEWAY){
                        ApiServices.shared.getTokenSessionCA { result in
                            switch result {
                            case .success(let token_klp):
                                print("✅ Lấy Session token CA thành công")
                                print("Session Token:", token_klp)
                            case .failure(let error):
                                print("❌ Lấy token thất bại", error.localizedDescription)
                            }
                        }
                    }
                    isStartingEkyc = false
                }
                .buttonStyle(CustomButtonStyle())
                
                PrimaryButton(title: "Start SDK", isDisabled: isStartingEkyc) {
                    guard !isStartingEkyc else { return }
                    
                    isStartingEkyc = true  // 🔒 khóa nút ngay
                    
                    Task { @MainActor in
                        // Đảm bảo gọi topViewController trên main thread
                        guard let vc = UIApplication.topViewController() else {
                            isStartingEkyc = false
                            return
                        }
                        
                        // Đảm bảo gọi startEkyc trên main thread
                        DispatchQueue.main.async {
                            CmcEkycSDKTest.startEkyc(from: vc)
                        }
                    }
                }
                
                .buttonStyle(CustomButtonStyle())
                
            }
            .padding()
            .toast(isShowing: $showToast, message: toastMessage, duration: 3.0)
        }
    }
}

#Preview {
    HomeView()
}

// Custom button style for better UI
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
