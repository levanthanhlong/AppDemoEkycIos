//
//  Data.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import CmcEkycSDK

class DataUtils {
    static var shared: Data = Data()
    static var SESSION: String = ""
    static var TOKEN = "5bb42ea331ee010001a0b7d7438s78vt8g62oul6943cra01xf28u48n"
    static var TOKEN_KLP: String = ""
    static var TOKEN_CA: String = ""
    static var SESSION_CA: String = ""
    static var FLOW_TYPE: CmcEkycFlowType = .nfcEkyc
    static var FLOW_API = "nfc_ekyc" // "nfc_only" "ekyc" "nfc_ekyc"
}


