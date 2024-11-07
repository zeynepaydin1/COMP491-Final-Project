//
//  BackgroundDS.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 10.01.2024.
//
import SwiftUI
struct BackgroundDS: View {
    var color1: Color
    var color2: Color
        var body: some View {
            LinearGradient(gradient: Gradient(colors: [color1, color2]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all) // To extend the gradient to the screen edges
        }
}
#Preview {
    BackgroundDS(color1: .blue, color2: .green)
}
