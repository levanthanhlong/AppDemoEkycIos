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
                    DataUtils.SESSION = ""
                    
                    ApiServices.shared.getToken { result in
                        switch result {
                        case .success(let session):
                            print("✅ Lấy Session thành công")
                            print("Session:", session)
                            print("Saved Session:", DataUtils.SESSION)
                            toastMessage = "✅ Lấy Session thành công"
                            isStartingEkyc = false
                            showToast = true
                            
                        case .failure(let error):
                            print("❌ Lấy token thất bại", error.localizedDescription)
                            toastMessage = "❌ Lấy token thất bại"
                            showToast = true
                        }
                    }
                    
                    
                    
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
