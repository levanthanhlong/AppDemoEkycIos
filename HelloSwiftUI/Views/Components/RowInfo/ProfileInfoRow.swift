//
//  ProfileInfoRow.swift
//  HelloSwiftUI
//
//  Created by ThanhLe on 17/12/25.
//
import SwiftUI

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View{
        HStack{
            Text(title+":").foregroundColor(.blue)
            Spacer().frame(width: 20)
            Text(value).foregroundColor(.gray)
        }.padding(20)
    }
}

#Preview {
    ProfileInfoRow(title: "Fullname", value: "Le Thanh")
}

