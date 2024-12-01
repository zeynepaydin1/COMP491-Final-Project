//
//  InputField.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/1/24.
//

import Foundation
import SwiftUI
struct InputField: View {
    var label: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(DesignSystem.Fonts.subheadline)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(DesignSystem.Colors.textSecondary))
                .autocapitalization(.none) // Disable auto-capitalization
                .keyboardType(.emailAddress) // Set keyboard type for email input
                .padding(DesignSystem.Spacing.inputPadding)
                .background(DesignSystem.Colors.inputBackground)
                .cornerRadius(DesignSystem.Corners.rounded)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Corners.rounded)
                        .stroke(text.isEmpty ? DesignSystem.Colors.textSecondary.opacity(0.4) : DesignSystem.Colors.textSecondary, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

