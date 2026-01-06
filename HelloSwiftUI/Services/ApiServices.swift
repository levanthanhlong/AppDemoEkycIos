//
//  ApiServices.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import Foundation

final class ApiServices {

    // MARK: - Singleton
    static let shared = ApiServices()
    private init() {}

    // MARK: - Constants
    private let baseURL = "\(AppConst.BASE_URL)/api/auth/get-token"
    private let authToken = AppConst.TOKEN

    // MARK: - Request Model
    private struct GetTokenRequest: Codable {
        let ekycSessionId: String
        let verify_check: Bool
        let fraud_check: Bool
        let accept_flash: Bool
        let strict_quality_check: Bool
        let scan_full_information: Bool
        let allow_sdk_full_results: Bool
        let flow: String
    }

    // MARK: - Response Model
    private struct GetTokenResponse: Codable {
        let token: String
        let short_token: String
        let client_id: String
        let flow: String
        let document_type: String
        let verify_check: Bool
        let fraud_check: Bool
        let accept_flash: Bool
        let strict_quality_check: Bool
        let scan_full_information: Bool
    }
    
    // MARK: - Request
    struct InitEkycRequest: Codable {
        let clientTransactionId: String
    }

    // MARK: - Response
    struct InitEkycResponse: Codable {
        let ekycSessionId: String
        let createdAt: String
    }

    // MARK: - Request
    struct LoginRequest: Codable {
        let username: String
        let password: String
    }

    // MARK: - Response
    struct LoginApiResponse: Codable {
        let success: Bool
        let data: LoginData?
        let errors: [LoginError]?
    }

    struct LoginData: Codable {
        let token: String
        let user: User
    }

    struct User: Codable {
        let id: String
        let username: String
        let role: String
        let organization: Organization?
    }

    struct Organization: Codable {
        let id: String
        let name: String
        let taxCode: String
    }

    struct LoginError: Codable {
        let code: String
        let message: String
    }


    // MARK: - API
    func getToken(completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let body = GetTokenRequest(
            ekycSessionId: DataUtils.SESSION_CA,
            verify_check: false,
            fraud_check: true,
            accept_flash: false,
            strict_quality_check: true,
            scan_full_information: true,
            allow_sdk_full_results: true,
            flow: DataUtils.FLOW_API
        )

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(GetTokenResponse.self, from: data)

                // ✅ Gán session theo yêu cầu
                DataUtils.SESSION = response.short_token

                completion(.success(response.short_token))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
    
    func login(
            username: String,
            password: String
        ) async throws -> LoginData {

            guard let url = URL(string: "\(AppConst.BASE_URL_CA)/api/auth/login") else {
                throw URLError(.badURL)
            }

            let body = LoginRequest(
                username: username,
                password: password
            )

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let apiResponse = try JSONDecoder().decode(LoginApiResponse.self, from: data)

            if apiResponse.success, let data = apiResponse.data {
                return data
            } else {
                let message = apiResponse.errors?.first?.message
                    ?? "Đăng nhập thất bại"
                throw NSError(
                    domain: "AUTH_ERROR",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: message]
                )
            }
        }
    
    
    func initEkycSession(
            clientTransactionId: String
        ) async throws -> String {

            guard let url = URL(string: "\(AppConst.BASE_URL_CA)/api/ekyc/init") else {
                throw URLError(.badURL)
            }

            let body = InitEkycRequest(
                clientTransactionId: clientTransactionId
            )

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            //  AUTH HEADER
            request.setValue(
                "Bearer \(DataUtils.TOKEN_CA)",
                forHTTPHeaderField: "Authorization"
            )

            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            if !(200...299).contains(httpResponse.statusCode) {
                let bodyString = String(data: data, encoding: .utf8) ?? "No response body"

                print("❌ EKYC INIT ERROR")
                print("Status code:", httpResponse.statusCode)
                print("Response body:", bodyString)

                throw NSError(
                    domain: "EKYC_INIT_ERROR",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: bodyString]
                )
            }

            let result = try JSONDecoder().decode(InitEkycResponse.self, from: data)

            // ✅ GÁN SESSION
            DataUtils.SESSION_CA = result.ekycSessionId

            print("✅ EKYC SESSION:", result.ekycSessionId)

            return result.ekycSessionId
        }
}

