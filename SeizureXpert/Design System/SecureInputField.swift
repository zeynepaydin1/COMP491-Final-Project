//
//  SecureInputField.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/1/24.
//

import Foundation
import SwiftUI

struct SecureInputField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    @Binding var isHidden: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(DesignSystem.Fonts.subheadline)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            HStack {
                if isHidden {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(DesignSystem.Colors.textSecondary))
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(DesignSystem.Colors.textSecondary))
                }
                Button(action: {
                    isHidden.toggle()
                }) {
                    Image(systemName: isHidden ? "eye.slash" : "eye")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
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

