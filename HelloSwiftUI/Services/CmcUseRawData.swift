//
//  CmcUseRawData.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 7/1/26.
//
import CmcEkycSDK

class CmcUseRawData: CmcRawDataDelegate {
    func handleNFCData(jsonNfc: [String : Any]) {
            print("📡 NFC RAW:", jsonNfc)
            // TODO: Khách hàng tự xử lý:
            // - Gửi lên server riêng
            // - Lưu local
            // - Encrypt
            // - Log, analytics...
        }

        func handleLivenessData(
            faceImageBase64String: String,
            variant: String
        ) {
            print("🙂 Liveness:", variant)
            print("Base64 length:", faceImageBase64String.count)
            // TODO: Tự xử lý ảnh mặt
        }

        func handleCaptureData(
            isFront: Bool,
            idCardImageBase64String: String
        ) {
            print("🪪 ID Card:", isFront ? "Front" : "Back")
            // TODO: Tự xử lý ảnh CCCD
        }
}
