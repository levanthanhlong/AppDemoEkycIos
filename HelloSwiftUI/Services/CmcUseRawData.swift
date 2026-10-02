//
//  CmcUseRawData.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 7/1/26.
//
import CmcEkycSDK
import KalapaSDK
class CmcUseRawData: CmcRawDataDelegate {
    func handleNFCData(jsonNfc: [String : Any]) {
        print("NFC RAW:", jsonNfc)
        // TODO: Khách hàng tự xử lý:
        // - Gửi lên server riêng
        // - Lưu local
        // - Encrypt
        // - Log, analytics...
        let sod = jsonNfc["sod"]
        let dg1 = jsonNfc["dg1"]
        let dg2 = jsonNfc["dg2"]
        let dg13 = jsonNfc["dg13"]
        let dscert = jsonNfc["dscert"]
        print("--------nfc dataa-----")
        print("sod: ", sod)
        print("dg1: ", dg1)
    }
    
    func handleLivenessData(
        faceImageBase64String: String,
        variant: String
    ) {
        print("Liveness:", variant)
        print("Base64 length:", faceImageBase64String.count)
        // TODO: Tự xử lý ảnh mặt
    }
    
    func handleCaptureData(
        isFront: Bool,
        idCardImageBase64String: String
    ) {
        print("ID Card:", isFront ? "Front" : "Back")
        // TODO: Tự xử lý ảnh CCCD
    }
    
//    func processQRCodeData(payload: String, completion: @escaping (KLPConfig.Result) -> Void) {
//            let fields = payload.components(separatedBy: "|")
//            guard fields.count >= 7, !fields[0].isEmpty else {
//                completion(.init(type: .failure, error: KalapaError(code: 400, message: "QR Code không hợp lệ")))
//                return
//            }
//            let data: [String: Any] = [
//                "id_number": fields[0],
//                "old_id_number": fields[1],
//                "name": fields[2],
//                "date_of_birth": fields[3],
//                "gender": fields[4],
//                "address": fields[5],
//                "date_of_issuance": fields[6]
//            ]
//            completion(.init(type: .success, dataResponse: data))
//        }
}
