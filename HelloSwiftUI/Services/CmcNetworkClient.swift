//
//  CmcNetworkClient.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 5/1/26.
//

import Foundation

import KalapaSDK
import SwiftUI



final class CmcNetworkClient {

    // MARK: - Singleton (optional)
    static let shared = CmcNetworkClient()
    private init() {}
    // MARK: - Core POST JSON with Auth
    func postNFCData(
        url: String,
        jsonBody: [String: Any],
        sessionId: String,
        token: String
    ) throws -> JSON {

        guard let url = URL(string: url) else {
            throw "Invalid URL"
        }
    
        let data = try JSONSerialization.data(
                withJSONObject: jsonBody,
                options: [.prettyPrinted]
            )

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 jsonBody:\n\(jsonString)")
        }
        guard
            let sod = jsonBody["sod"],
            let dg1 = jsonBody["dg1"],
            let dg2 = jsonBody["dg2"],
            let dg13 = jsonBody["dg13"],
            let dg14 = jsonBody["dg14"]
        else {
            throw "Missing NFC data"
        }


        let body: [String: Any] = [
            "sodData": sod,
            "dg1DataB64": dg1,
            "dg2DataB64": dg2,
            "dg13DataB64": dg13,
            "dg14DataB64": dg14,
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "X-EKYC-Session-Id")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<JSON, String>!

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                result = .failure(error.localizedDescription)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                result = .failure("No response")
                return
            }

            guard let data = data else {
                result = .failure("Empty response body")
                return
            }

            print("POST \(url) -> code=\(http.statusCode)")

            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                result = .failure("HTTP \(http.statusCode): \(body)")
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? JSON else {
                result = .failure("Invalid JSON")
                return
            }

            result = .success(json)
        }.resume()

        semaphore.wait()
        return try result.get()
    }
    
    func postJsonWithAuth(
        url: String,
        jsonBody: [String: Any],
        sessionId: String,
        token: String
    ) throws -> JSON {

        guard let url = URL(string: url) else {
            throw "Invalid URL"
        }
    
        let data = try JSONSerialization.data(
                withJSONObject: jsonBody,
                options: [.prettyPrinted]
            )

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 jsonBody:\n\(jsonString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "X-EKYC-Session-Id")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<JSON, String>!

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                result = .failure(error.localizedDescription)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                result = .failure("No response")
                return
            }

            guard let data = data else {
                result = .failure("Empty response body")
                return
            }

            print("POST \(url) -> code=\(http.statusCode)")

            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                result = .failure("HTTP \(http.statusCode): \(body)")
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? JSON else {
                result = .failure("Invalid JSON")
                return
            }

            result = .success(json)
        }.resume()

        semaphore.wait()
        return try result.get()
    }

    // MARK: - Capture Validate
    func processCaptureValidate(
        documentBase64: String,
        isFront: Bool,
        baseUrl: String,
        sessionId: String,
        token: String
    ) throws -> JSON {

        let url = isFront
            ? "\(baseUrl)/api/ekyc/kalapa/scan-front"
            : "\(baseUrl)/api/ekyc/kalapa/scan-back"

        let response = try postJsonWithAuth(
            url: url,
            jsonBody: ["image": documentBase64],
            sessionId: sessionId,
            token: token
        )

        print("Capture cmc response:", response)
        return response
    }



    // MARK: - NFC Validate
    func processNfcAndValidate(
        jsonNfc: [String: Any],
        baseUrl: String,
        sessionId: String,
        token: String
    ) throws -> JSON {

        let response = try postNFCData(
            url: "\(baseUrl)/api/ekyc/card/validate",
            jsonBody: jsonNfc,
            sessionId: sessionId,
            token: token
        )
        print("NFC cmc response:", response)
        return response
    }


    // MARK: - Liveness Verify
    func processLivenessAndVerify(
        portraitBase64: String,
        baseUrl: String,
        sessionId: String,
        token: String
    ) throws -> JSON {

        let response = try postJsonWithAuth(
            url: "\(baseUrl)/api/ekyc/face/verify",
            jsonBody: ["liveImage": portraitBase64],
            sessionId: sessionId,
            token: token
        )

        print("Live cmc response: \(response)")

        return response
    }



    // MARK: - Multipart Upload
    func postMultipart(
        url: String,
        headers: [String: String] = [:],
        fieldName: String = "image",
        fileName: String,
        mimeType: String = "image/jpeg",
        fileData: Data
    ) throws -> JSON {

        guard let url = URL(string: url) else {
            throw "Invalid URL"
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue("application/json", forHTTPHeaderField: "accept")

        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append(
            "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
                .data(using: .utf8)!
        )
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<JSON, String>!

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                result = .failure(error.localizedDescription)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                result = .failure("No response")
                return
            }

            guard let data = data else {
                result = .failure("Empty response body")
                return
            }

            print("POST \(url) -> code=\(http.statusCode)")

            guard (200...299).contains(http.statusCode) else {
                result = .failure("HTTP \(http.statusCode)")
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? JSON
            else {
                result = .failure("Invalid JSON")
                return
            }

            result = .success(json)
        }.resume()

        semaphore.wait()
        return try result.get()
    }
    func callNfcVerifyApiKala(
        jsonNfc: [String: Any],
        baseUrl: String,
        sessionId: String
    ) throws -> JSON {
        
        let jsonData = try JSONSerialization.data(
            withJSONObject: jsonNfc,
            options: []
        )
    
        
        let encryptedData = Kalapa.shared.encrypt(data: jsonData)

        let bodyDict: JSON = [
            "data": encryptedData
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: bodyDict)

        guard let url = URL(string: "\(baseUrl)/api/nfc/verify") else {
            throw "Invalid URL"
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "Authorization")
        request.httpBody = bodyData
        request.timeoutInterval = 30

        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<JSON, String>!

        URLSession.shared.dataTask(with: request) { data, _, error in
            defer { semaphore.signal() }

            if let error = error {
                result = .failure(error.localizedDescription)
                return
            }

            guard let data = data else {
                result = .failure("Empty response body")
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? JSON
            else {
                result = .failure("Invalid JSON")
                return
            }

            print("NFC verify response:", json)

            if let errorObj = json["error"] as? JSON {
                let code = errorObj["code"] as? Int ?? 0
                let message = errorObj["message"] as? String ?? "NFC verify failed"

                code == 200
                    ? (result = .success(json))
                    : (result = .failure(message))
            } else {
                result = .success(json)
            }
        }.resume()

        semaphore.wait()
        return try result.get()
    }

    
    func callDocumentScanApiKala(
        documentBase64: String,
        isFront: Bool,
        baseUrl: String,
        sessionId: String
    ) throws -> JSON {

        let url = isFront == true
            ? "\(baseUrl)/api/kyc/scan-front"
            : "\(baseUrl)/api/kyc/scan-back"

        guard let imageData = Data(base64Encoded: documentBase64) else {
            throw "Invalid base64 image"
        }

        let response = try postMultipart(
            url: url,
            headers: ["Authorization": sessionId],
            fileName: "document.jpg",
            fileData: imageData
        )

        print("Document scan response:", response)

        if let errorObj = response["error"] as? JSON {
            let code = errorObj["code"] as? Int ?? 0
            let message = errorObj["message"] as? String ?? "Document scan failed"

            if code != 0 {
                throw message
            }
        }

        return response
    }

    
    func callLivenessCheckApiKala(
        portraitBase64: String,
        baseUrl: String,
        sessionId: String
    ) throws -> JSON {

        guard let imageData = Data(base64Encoded: portraitBase64) else {
            throw "Invalid base64 image"
        }

        let response = try postMultipart(
            url: "\(baseUrl)/api/kyc/check-selfie",
            headers: ["Authorization": sessionId],
            fileName: "selfie.jpg",
            fileData: imageData
        )

        print("Liveness response:", response)

        if let errorObj = response["error"] as? JSON {
            let code = errorObj["code"] as? Int ?? 0
            let message = errorObj["message"] as? String ?? "Liveness check failed"

            if code != 0 {
                throw message
            }
        }

        return response
    }

}


extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}

extension String: Error {}

typealias JSON = [String: Any]
