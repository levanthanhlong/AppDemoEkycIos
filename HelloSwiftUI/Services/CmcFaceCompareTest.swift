//
//  CmcFaceCompareTest.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 12/10/26.
//

import CmcEkycSDK
import UIKit

final class CmcFaceCompareTest {

    static func startFaceCompare(from viewController: UIViewController, storedPortraitBase64: String) {
        CmcEkycManager.shared.startFaceCompare(
            from: viewController,
            baseUrl: AppConst.BASE_URL_CA,
            token: DataUtils.TOKEN_CA, // JWT từ /api/auth/login
            ekycSessionId: DataUtils.ekycSessionId, // từ /api/ekyc/init
            storedPortraitBase64: storedPortraitBase64,
            language: "vi",
            livenessTimeout: 30,
            onResult: { result in
                guard let result else {
                    print("Face compare: người dùng thoát màn hình liveness")
                    return
                }
                print("Face compare result:", result.isMatched, result.matchingScore, result.httpStatusCode, result.requestId ?? "-")
                showAlert(title: "Face Compare", message: message(for: result))
            },
            onShowLoading: {
                // SDK đang gọi API so khớp
                LoadingOverlay.show()
            },
            onHideLoading: {
                // SDK đã gọi xong
                LoadingOverlay.hide()
            }
        )
    }

    private static func message(for result: CmcFaceCompareResult) -> String {
        let status: String
        if result.isMatched {
            status = "✅ Khuôn mặt khớp"
        } else if result.isCompleted {
            status = "❌ \(result.errorMessage ?? "Khuôn mặt không khớp")"
        } else {
            status = "⚠️ Lỗi: \(result.errorMessage ?? "Không xác định")"
        }
        return """
        \(status)
        Score: \(result.matchingScore)
        HTTP: \(result.httpStatusCode)
        Request ID: \(result.requestId ?? "-")
        """
    }

    private static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
}

/// Loading gắn thẳng vào key window để nằm trên màn hình liveness của SDK
private enum LoadingOverlay {

    private static var overlayView: UIView?

    static func show() {
        DispatchQueue.main.async {
            guard overlayView == nil, let window = keyWindow() else { return }

            let overlay = UIView(frame: window.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.startAnimating()

            let label = UILabel()
            label.text = "Đang so khớp khuôn mặt..."
            label.textColor = .white

            let stack = UIStackView(arrangedSubviews: [indicator, label])
            stack.axis = .vertical
            stack.spacing = 12
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            overlay.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])

            window.addSubview(overlay)
            overlayView = overlay
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            overlayView?.removeFromSuperview()
            overlayView = nil
        }
    }

    private static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
}
