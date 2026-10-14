////
////  ProfileView.swift
////  HelloSwiftUI
////
////  Created by ThanhLe on 17/12/25.
////
import PhotosUI
import SwiftUI

struct HomeView: View {
    @State private var isStartingEkyc = true
    @State private var toastMessage = ""
    @State private var showToast = false
    @State private var selectedPortraitItem: PhotosPickerItem?
    @State private var storedPortraitBase64: String?
    
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

                // Face Compare: chọn ảnh chân dung đã có, rồi so khớp với ảnh liveness
                PhotosPicker(selection: $selectedPortraitItem, matching: .images) {
                    Text(storedPortraitBase64 == nil ? "Chọn ảnh chân dung" : "Đã chọn ảnh chân dung ✓")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue))
                }
                .onChange(of: selectedPortraitItem) { item in
                    loadPortrait(from: item)
                }

                PrimaryButton(
                    title: "Start Face Compare",
                    isDisabled: storedPortraitBase64 == nil
                ) {
                    guard let storedPortraitBase64,
                          let vc = UIApplication.topViewController() else { return }
                    CmcFaceCompareTest.startFaceCompare(from: vc, storedPortraitBase64: storedPortraitBase64)
                }

            }
            .padding()
            .toast(isShowing: $showToast, message: toastMessage, duration: 3.0)
        }
    }

    /// Đọc ảnh đã chọn, nén JPEG rồi chuyển sang Base64
    private func loadPortrait(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let jpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.9) else {
                toastMessage = "Không đọc được ảnh"
                showToast = true
                return
            }
            storedPortraitBase64 = jpeg.base64EncodedString()
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
