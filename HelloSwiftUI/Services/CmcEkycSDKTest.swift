//
//  CmcEkycSDKTest.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//


import SwiftUI
import CmcEkycSDK
import UIKit



final class CmcEkycSDKTest {
    
    static func startEkyc(from viewController: UIViewController) {
        
        let rawDataProcessor = CmcProcessor()
        
        CmcEkycManager.shared.startEkyc(
            from: viewController,
            sessionCA: DataUtils.SESSION_CA,
            tokenCA: DataUtils.TOKEN_CA,
            baseUrlCA: AppConst.BASE_URL_CA,
            session: DataUtils.SESSION,
            tokenCAKLP: DataUtils.TOKEN_KLP,
            token: AppConst.TOKEN,
            baseUrl: AppConst.BASE_URL,
            language: "vi",
            mainColor: "#6CB096",
            btnTextColor: "#FFFFFF",
            backgroundColor: "#FFFFFF",
            isAnimatedBtn: true,
            isShowResultScreen: true,
            customerLanguage: nil,
            scanNFCTimeout: 30,
            livenessTimeout: 30,
            enableQRCode: false,
            livenessVersion: .passive,
            isOnlyShowReasonInResultVC: false,
            cornerRadiusBtn: 10,
            flowType: DataUtils.FLOW_TYPE,
            mrz: nil,
            faceData: nil,
            onResult: { result in
                print("eKYC result name:", result?.nfcResult?.name ?? "null")
                print("eKYC result decision:", result?.decision ?? "null")
                // Hiển thị pop-up với decision
                DispatchQueue.main.async {
                    print("Show decision pop-up: \(result?.decision ?? "No decision available")")
                    let alert = UIAlertController(
                        title: "eKYC Decision",
                        message: result?.decision ?? "No decision available",
                        preferredStyle: .alert
                    )
                    
                    // Thêm hành động khi nhấn OK
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        guard let nfcResult = result?.nfcResult else { return }
                        // Sau khi nhấn OK, chuyển sang màn EkycNfcResultView
                        let view = EkycNfcResultView(nfcResult: nfcResult)
                        let hostingVC = UIHostingController(
                            rootView: NavigationView {
                                view
                            }
                        )
                        hostingVC.modalPresentationStyle = .fullScreen
                        viewController.present(hostingVC, animated: true)
                    }))
                    
                    // Hiển thị pop-up
                    viewController.present(alert, animated: true)
                }
                guard let nfcResult = result?.nfcResult else { return }
                DispatchQueue.main.async {
                    let view = EkycNfcResultView(nfcResult: nfcResult)
                    
                    let hostingVC = UIHostingController(
                        rootView: NavigationView {
                            view
                        }
                    )
                    hostingVC.modalPresentationStyle = .fullScreen
                    
                    viewController.present(hostingVC, animated: true)
                }
            },
            onShowError: { message, vc in
                print("Error:", message ?? "")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: message ?? "An error occurred.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    vc.present(alert, animated: true)
                }
            },
            
            rawDataProcessor: rawDataProcessor,
            errorScanNFCCallback: { error, errorDescription, retry, dismiss in
                // In ra lỗi NFC vào console
                print("NFC Error: \(error), Description: \(errorDescription ?? "No description")")
                
                // Đảm bảo hiển thị UIAlertController trên main thread
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "NFC Error",
                        message: errorDescription ?? "An unknown error occurred while scanning NFC.",
                        preferredStyle: .alert
                    )
                    
                    // Thêm hành động Retry
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        retry?()  // Gọi closure retry nếu người dùng muốn thử lại
                    }))
                    
                    // Thêm hành động Dismiss
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
                        dismiss?()  // Gọi closure dismiss nếu người dùng muốn đóng thông báo
                    }))
                    
                    // Hiển thị popup lỗi NFC
                    if let viewController = UIApplication.topViewController() {
                        viewController.present(alert, animated: true, completion: nil)
                    } else {
                        print("Error: Unable to find the top view controller.")
                    }
                }
            }
        )
    }
}

