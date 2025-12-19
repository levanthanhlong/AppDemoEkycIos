////
////  KalapaSDK.swift
////  HelloSwiftUI
////
////  Created by ThanhLe on 18/12/25.
////
//
//
//import Foundation
//import KalapaSDK
//
//class KalapaServices {
//    public static func kalapaSDK(){
//        let appearance = KLPAppearance.Builder().build()
//        var config = KLPConfig.Builder(session:Data.session)
//            .withAppearance(appearance)
//            .withSession(Data.session)
//            .withBaseUrl(AppConst.BASE_URL)
//            .withResultHandler { result in
//                print("eKYC success:", result?.decision)
//            }.withLivenessTimeoutSeconds(20)
//        
//        let flowType: KLPFlowType = KLPFlowType.nfc_only(mrz: nil, faceData: nil)
//        // start the SDK
//        Task{ @MainActor in
//            do{
//                try await config.build()
//                
//                Kalapa.shared.run(flowType: flowType, withConfig: config)
//                
//            }catch{
//                print(error)
//            }
//        }
//        //return "Hello, World!"
//    }
//}
//
//
