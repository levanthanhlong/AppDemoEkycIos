////
////  ContentView.swift
////  HelloSwiftUI
////
////  Created by ThanhLe on 17/12/25.
////
//
//import SwiftUI
//import CmcEkycSDK
//struct ContentView: View {
//    // "nfc_only" "ekyc" "nfc_ekyc"
//    
//    @State private var navigateToHomeView = false
//    @State private var showToast: Bool = false
//    @State private var toastMessage: String = ""
//    @State private var isClidked: Bool = false
//    var body: some View {
//        NavigationStack{
//            VStack(spacing: 20){
//                Text("Option flow:")
//                PrimaryButton(title: "test flow nfc_only"){
//                    Data.FLOW_API = "nfc_only"
//                    Data.FLOW_TYPE = .nfcOnly
//                }.frame(width: 150)
//                PrimaryButton(title: "test flow ekyc"){
//                    Data.FLOW_API = "ekyc"
//                    Data.FLOW_TYPE = .ekyc
//                }.frame(width: 150)
//                PrimaryButton(title: "test flow nfc_ekyc"){
//                    Data.FLOW_API = "nfc_ekyc"
//                    Data.FLOW_TYPE = .nfcEkyc
//                }.frame(width: 150)
//                
//                NavigationLink(destination: HomeView()){
//                    Text("Go to Home")
//                }.foregroundColor(.red)
//            }
//        }.padding().toast(isShowing: $showToast, message: toastMessage)
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI
import CmcEkycSDK

struct ContentView: View {
    // "nfc_only" "ekyc" "nfc_ekyc"
    
    @State private var selectedFlow: String? = nil // Để lưu lựa chọn
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var isClicked: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Option flow:")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Nút checklist với Toggle
                checklistButton(title: "nfc_only", flow: "nfc_only")
                checklistButton(title: "ekyc", flow: "ekyc")
                checklistButton(title: "nfc_ekyc", flow: "nfc_ekyc")
                
                // Thêm một nút "Go to Home"
                NavigationLink(destination: HomeView()) {
                    Text("Go to Home")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
            }
            .padding()
            .toast(isShowing: $showToast, message: toastMessage)
        }
    }
    
    // Nút Checklist
    private func checklistButton(title: String, flow: String) -> some View {
        HStack {
            Text(title.capitalized)
                .font(.title2)
                .foregroundColor(.black)
            
            Spacer()
            
            // Toggle cho checklist
            Toggle("", isOn: Binding(
                get: { selectedFlow == flow },
                set: { newValue in
                    if newValue {
                        selectedFlow = flow
                    } else if selectedFlow == flow {
                        selectedFlow = nil
                    }
                    // Cập nhật Data theo lựa chọn
                    Data.FLOW_API = flow
                    Data.FLOW_TYPE = flow == "nfc_only" ? .nfcOnly : (flow == "ekyc" ? .ekyc : .nfcEkyc)
                }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .labelsHidden()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .shadow(radius: 3)
    }
}

#Preview {
    ContentView()
}
