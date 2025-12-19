//
//  PrimaryButton.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 17/12/25.
//

import SwiftUI

struct PrimaryButton: View {

    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(isDisabled ? Color.gray : Color.blue)
                .cornerRadius(12)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)
    }
}


#Preview {
    PrimaryButton(title: "String"){
        
    }
}
