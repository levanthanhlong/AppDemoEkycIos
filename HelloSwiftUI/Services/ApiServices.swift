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

    // MARK: - API
    func getToken(completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let body = GetTokenRequest(
            verify_check: false,
            fraud_check: true,
            accept_flash: false,
            strict_quality_check: true,
            scan_full_information: true,
            allow_sdk_full_results: true,
            flow: Data.FLOW_API
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
                Data.session = response.short_token

                completion(.success(response.short_token))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}

