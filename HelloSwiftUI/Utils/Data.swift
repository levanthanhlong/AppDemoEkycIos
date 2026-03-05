//
//  Data.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import CmcEkycSDK

class DataUtils {
    static var shared: Data = Data()
    static var ekycSessionId = "" // Lấy từ https://csign.cmcuat.cloud/api/ekyc/init
    static var SESSION: String = "" // Lấy từ api: https://csign.cmcuat.cloud/api/ekyc/kalapa/init-session
    static var TOKEN_KLP: String = "" // lấy từ api: https://csign.cmcuat.cloud/api/ekyc/kalapa/init-session
    static var TOKEN_CA: String = "" // Lấy từ api: https://csign.cmcuat.cloud/api/auth/login
    static var SESSION_CA: String = "" // Lấy từ api: https://csign.cmcuat.cloud/api/ekyc/kalapa/init-session
    static var FLOW_TYPE: CmcEkycFlowType = .nfcEkyc
    static var FLOW_API = "nfc_ekyc" // "nfc_only" "ekyc" "nfc_ekyc"
}


