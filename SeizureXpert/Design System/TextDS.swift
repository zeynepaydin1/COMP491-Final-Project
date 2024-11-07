//
//  TextDS.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 10.01.2024.
//
import SwiftUI
// Button Text
struct ButtonTextDS: View {
    let text: String
    var body: some View {
        Text(text)
            .lineLimit(2)
            .font(.custom("SFProText-Regular", size: 17))
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
    }
}
// Heading 1 Text
struct Heading1TextWhite: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold, design: .default))
            .foregroundColor(.white)
            .lineLimit(nil)
    }
}
struct Heading1TextBlack: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold, design: .default))
            .foregroundColor(.black)
            .lineLimit(nil)
    }
}
// Body Text
struct BodyText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.custom("SFProText-Regular", size: 16))
            .foregroundColor(.gray)
            .lineLimit(nil)
    }
}
// Caption Text
struct CaptionText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.custom("SFProText-Regular", size: 12))
            .foregroundColor(.secondary)
            .lineLimit(nil)
    }
}
