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
            scanNFCTimeout: 10,
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
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Loading",
                        message: "Please wait, loading data...",
                        preferredStyle: .alert
                    )
                    // Nếu bạn muốn hiển thị spinner trong khi chờ
                    let loadingIndicator = UIActivityIndicatorView(style: .medium)
                    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
                    loadingIndicator.startAnimating()
                    alert.view.addSubview(loadingIndicator)
                    NSLayoutConstraint.activate([
                        loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                        loadingIndicator.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 30)
                    ])
                    viewController.present(alert, animated: true)
                }
            },
            onHideLoading: {
                print("Hide loading")
                DispatchQueue.main.async {
                    if let presentedVC = viewController.presentedViewController as? UIAlertController {
                        presentedVC.dismiss(animated: true, completion: nil)
                    }
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
            onTimeoutScanNFC: { retry in
                print("Timeout NFC")
    
            },

            rawDataProcessor: nil
        )
    }
}

