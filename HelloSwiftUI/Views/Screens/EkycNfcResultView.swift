//
//  Untitled.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 19/12/25.
//

import SwiftUI
import CmcEkycSDK


struct EkycNfcResultView: View {

    let nfcResult: CmcEkycNfcResult
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: - Header
                VStack(spacing: 8) {
                    Text("Kết quả NFC")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(nfcResult.name ?? "--")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                // MARK: - Info Card
                infoCard(title: "Thông tin cá nhân") {
                    infoRow("Số CCCD", nfcResult.idNumber)
                    infoRow("Họ tên", nfcResult.name)
                    infoRow("Ngày sinh", nfcResult.dateOfBirth)
                    infoRow("Giới tính", nfcResult.gender)
                    infoRow("Quốc tịch", nfcResult.nationality)
                }

                infoCard(title: "Thông tin giấy tờ") {
                    infoRow("Ngày cấp", nfcResult.dateOfIssuance)
                    infoRow("Ngày hết hạn", nfcResult.dateOfExpiry)
                    infoRow("Số CCCD cũ", nfcResult.oldIdNumber)
                }

                infoCard(title: "Thông tin bổ sung") {
                    infoRow("Quê quán", nfcResult.hometown)
                    infoRow("Địa chỉ", nfcResult.address)
                    infoRow("Dân tộc", nfcResult.nation)
                    infoRow("Tôn giáo", nfcResult.religion)
                }

                infoCard(title: "Gia đình") {
                    infoRow("Tên cha", nfcResult.fatherName)
                    infoRow("Tên mẹ", nfcResult.motherName)
                    infoRow("Vợ / Chồng", nfcResult.spouseName)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("eKYC Result", displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
               .toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button {
                           dismiss()
                       } label: {
                           Image(systemName: "chevron.left")
                       }
                   }
               }
        
    }

    // MARK: - UI Components

    private func infoCard(
        title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }

    private func infoRow(_ title: String, _ value: String?) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value ?? "--")
                .fontWeight(.medium)
        }
        .font(.system(size: 15))
    }
}
 
