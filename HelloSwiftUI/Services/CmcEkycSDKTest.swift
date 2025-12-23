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
        CmcEkycManager.shared.startEkyc(
            from: viewController,
            session: Data.session,
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
            flowType: Data.FLOW_TYPE,
            mrz: nil,
            faceData: nil,
            onResult: { result in
                print("eKYC result:", result?.nfcResult?.name ?? "null")
                guard let nfcResult = result?.nfcResult else { return }
                print("eKYC result:", result?.nfcResult?.name ?? "null")
                guard let nfcResult = result?.nfcResult else { return }
                
                // Hiển thị pop-up với decision
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "eKYC Decision",
                        message: result?.decision ?? "No decision available",
                        preferredStyle: .alert
                    )
                    
                    // Thêm hành động khi nhấn OK
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
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
            onEvent: { event in
                print("eKYC event:", event.rawValue)
            },
            onShowLoading: {
                print("Show loading")
//                DispatchQueue.main.async {
//                    // Tạo UIAlertController
//                    let alert = UIAlertController(
//                        title: "Loading",
//                        message: "Please wait, loading data...",
//                        preferredStyle: .alert
//                    )
//                    
//                    // Tạo UIActivityIndicatorView để hiển thị spinner
//                    let loadingIndicator = UIActivityIndicatorView(style: .medium)
//                    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
//                    loadingIndicator.startAnimating()  // Bắt đầu quay spinner
//                    
//                    // Thêm spinner vào UIAlertController's view
//                    alert.view.addSubview(loadingIndicator)
//                    
//                    // Đảm bảo spinner được căn giữa trong UIAlertController
//                    NSLayoutConstraint.activate([
//                        loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
//                        loadingIndicator.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 30)
//                    ])
//                    
//                    // Hiển thị UIAlertController
//                    if let viewController = UIApplication.topViewController() {
//                        viewController.present(alert, animated: true, completion: nil)
//                        
//                        // Cố định thời gian 3 giây, sau đó dismiss alert (ẩn spinner)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Sau 3 giây
//                            alert.dismiss(animated: true, completion: {
//                                print("Loading finished and alert dismissed.")
//                            })
//                        }
//                    } else {
//                        print("Error: Unable to find the top view controller.")
//                    }
//                }
            },

            onHideLoading: {
                print("Hide loading")
//                DispatchQueue.main.async {
//                    // Kiểm tra nếu UIAlertController đang được hiển thị
//                    if let presentedVC = viewController.presentedViewController as? UIAlertController {
//                        // Nếu có, ẩn UIAlertController
//                        presentedVC.dismiss(animated: true, completion: nil)
//                    }
//                }
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
            
            rawDataProcessor: nil,
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

