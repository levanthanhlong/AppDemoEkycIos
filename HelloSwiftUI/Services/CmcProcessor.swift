//
//  CmcProcessor.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 23/12/25.
//

import CmcEkycSDK
import KalapaSDK

class CmcProcessor: NSObject, CmcRawDataProcessor {
    // Xử lý dữ liệu NFC
    func processNFCData(jsonNfc: [String : Any], completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1))  {
            do {
                // ✅ VALIDATE TRƯỚC
                guard !DataUtils.TOKEN_CA.isEmpty,
                      !DataUtils.SESSION_CA.isEmpty else {
                    throw "TOKEN_CA or SESSION_CA is empty"
                }
                
                // ✅ CALL CA BACKEND (BACKGROUND)
                let jsonCA = try CmcNetworkClient.shared.processNfcAndValidate(
                    jsonNfc: jsonNfc,
                    baseUrl: AppConst.BASE_URL_CA,
                    sessionId: DataUtils.SESSION_CA,
                    token: DataUtils.TOKEN_CA
                )
                
                print("jsonCA: \(jsonCA)")
                let json = try CmcNetworkClient.shared.callNfcVerifyApiKala(
                    jsonNfc: jsonNfc,
                    baseUrl: AppConst.BASE_URL,
                    sessionId: DataUtils.SESSION
                )
                DispatchQueue.main.async {
                    completion(.init(type: .success, dataResponse: json["data"] as? JSON ?? [:]))
                }
                
            } catch let error as String {
                DispatchQueue.main.async {
                    completion(.init(type: .failure, error: KalapaError(code: 400, message: error)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.init(type: .failure, error: KalapaError(code: 400, message: error.localizedDescription)))
                }
            }
        }
    }
    
    // Xử lý dữ liệu liveness
    func processLivenessData(
        faceImageData: NSData,
        faceImageBase64String: String,
        variant: String,
        completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                var jsonCA = try CmcNetworkClient.shared.processLivenessAndVerify(portraitBase64: faceImageBase64String, baseUrl: AppConst.BASE_URL_CA, sessionId: DataUtils.SESSION_CA, token: DataUtils.TOKEN_CA)
                print("jsonCA: \(jsonCA)")
                
                let json = try CmcNetworkClient.shared.callLivenessCheckApiKala(
                    portraitBase64: faceImageBase64String,
                    baseUrl: AppConst.BASE_URL,
                    sessionId: DataUtils.SESSION
                )
                DispatchQueue.main.async {
                    completion(.init(type: .success, dataResponse: json["data"] as? JSON ?? [:]))
                }
                
            } catch let error as String {
                DispatchQueue.main.async {
                    completion(
                        .init(
                            type: .failure,
                            error: KalapaError(code: 400, message: error)
                        )
                    )
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(
                        .init(
                            type: .failure,
                            error: KalapaError(code: 400, message: error.localizedDescription)
                        )
                    )
                }
            }
        }
    }
    
    
    // Xử lý dữ liệu thẻ ID
    func processCaptureData(
        isFront: Bool,
        idCardImageData: NSData,
        idCardImageBase64String: String,
        completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                var jsonCA = try CmcNetworkClient.shared.processCaptureValidate(documentBase64: idCardImageBase64String, isFront: isFront, baseUrl: AppConst.BASE_URL_CA, sessionId: DataUtils.TOKEN_KLP, token: DataUtils.TOKEN_CA)
                print("jsonCA: \(jsonCA)")
                
                let json = try CmcNetworkClient.shared.callDocumentScanApiKala(
                    documentBase64: idCardImageBase64String,
                    isFront: isFront,
                    baseUrl: AppConst.BASE_URL,
                    sessionId: DataUtils.SESSION
                )
                DispatchQueue.main.async {
                    completion(.init(type: .success, dataResponse: json["data"] as? JSON ?? [:]))
                }
                
            } catch let error as String {
                print("error: \(error)")
                DispatchQueue.main.async {
                    completion(
                        .init(
                            type: .failure,
                            error: KalapaError(code: 400, message: error)
                        )
                    )
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(
                        .init(
                            type: .failure,
                            error: KalapaError(code: 400, message: error.localizedDescription)
                        )
                    )
                }
            }
        }
    }
    
    
    // Xử lý dữ liệu QR Code
    func processQRCodeData(payload: String, completion: @escaping (KalapaSDK.KLPConfig.Result) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("Processing QR Code Data with payload: \(payload)")
            // Giả sử kết quả thành công
            // completion(.init(type: .success, dataResponse: [:]))
            // Hoặc trường hợp thất bại
            // completion(.init(type: .failure, error: KalapaError(code: 400, message: "QR Code error")))
        })
    }
}
