//
//  SecureFieldDS.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
import SwiftUI
struct SecureFieldDSWhite: View {
    @Binding var text: String
    var placeholder: String
    var body: some View {
        SecureField(placeholder, text: $text)
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
struct SecureFieldDSBlack: View {
    @Binding var text: String
    var placeholder: String
    var body: some View {
        SecureField(placeholder, text: $text)
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
