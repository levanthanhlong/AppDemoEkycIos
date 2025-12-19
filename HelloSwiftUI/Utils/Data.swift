//
//  Data.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import CmcEkycSDK

class Data {
    static var shared: Data = Data()
    static var session: String = ""
    static var FLOW_TYPE: CmcEkycFlowType = .nfcEkyc
    static var FLOW_API = "nfc_ekyc" // "nfc_only" "ekyc" "nfc_ekyc"
}


