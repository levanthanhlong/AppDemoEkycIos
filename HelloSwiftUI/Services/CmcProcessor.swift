//
//  CmcProcessor.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 23/12/25.
//

import CmcEkycSDK
import KalapaSDK

class CmcProcessor: CmcRawDataProcessor {    
    // Xử lý dữ liệu NFC
    func processNFCData(jsonNfc: [String : Any], completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("Processing NFC Data with: \(jsonNfc)")
            // Giả sử kết quả thành công
            completion(.init(type: .success, dataResponse: [:]))
            // Hoặc trường hợp thất bại
            // completion(.init(type: .failure, error: "NFC data error"))
        })
    }
    
    // Xử lý dữ liệu liveness
    func processLivenessData(faceImageData: NSData, faceImageBase64String: String, variant: String, completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("Processing Liveness Data with variant: \(variant)")
            // Giả sử kết quả thành công
            completion(.init(type: .success, dataResponse: [:]))
            // Hoặc trường hợp thất bại
            // completion(.init(type: .failure, error: "Liveness data error"))
        })
    }
    
    // Xử lý dữ liệu thẻ ID
    func processCaptureData(isFront: Bool, idCardImageData: NSData, idCardImageBase64String: String, completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("Processing Capture Data, Front: \(isFront)")
            // Giả sử kết quả thành công
            completion(.init(type: .success, dataResponse: [:]))
            // Hoặc trường hợp thất bại
            // completion(.init(type: .failure, error: "Capture data error"))
        })
    }
    
    // Xử lý dữ liệu QR Code
    func processQRCodeData(payload: String, completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("Processing QR Code Data with payload: \(payload)")
            // Giả sử kết quả thành công
            completion(.init(type: .success, dataResponse: [:]))
            // Hoặc trường hợp thất bại
            // completion(.init(type: .failure, error: "QR Code error"))
        })
    }
}
