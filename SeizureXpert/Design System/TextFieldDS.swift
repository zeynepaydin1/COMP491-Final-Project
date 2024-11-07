//
//  TextFieldDS.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 10.01.2024.
//
import SwiftUI
struct TextFieldDSWhite: View {
    @Binding var text: String
    var placeholder: String
    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: Radius.radius_3)
                    .stroke(Color.white, lineWidth: 2)
            )
            .font(.custom("SFProText-Regular", size: 16))
            .foregroundColor(.white)
            .accentColor(.white)
    }
}
struct TextFieldDSBlack: View {
    @Binding var text: String
    var placeholder: String
    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: Radius.radius_3)
                    .stroke(Color.black, lineWidth: 2)
            )
            .font(.custom("SFProText-Regular", size: 16))
            .foregroundColor(.black)
            .accentColor(.black)
    }
}
