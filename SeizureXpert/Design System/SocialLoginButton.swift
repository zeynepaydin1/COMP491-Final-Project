//
//  SocialLoginButton.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/1/24.
//

import Foundation
import SwiftUI

struct SocialLoginButton: View {
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .frame(width: DesignSystem.ImageSizes.socialIcon.width, height: DesignSystem.ImageSizes.socialIcon.height)
                .foregroundColor(DesignSystem.Colors.primary)
        }
    }
}

