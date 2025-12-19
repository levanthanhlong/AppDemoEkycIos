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
            scanNFCTimeout: 60,
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
                print("eKYC event:", event)
            },
            onShowLoading: {
                print("Show loading")
            },
            onHideLoading: {
                print("Hide loading")
            },
            onShowError: { message, vc in
                print("Error:", message ?? "")
            },
            onTimeoutScanNFC: { retry in
                print("Timeout NFC")
                retry?() // gọi lại scan NFC nếu cần
            }
        )
    }
}

