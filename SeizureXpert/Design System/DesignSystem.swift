//
//  DesignSystem.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/1/24.
//

import SwiftUI

struct DesignSystem {
    // Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let background = Color.white
        static let inputBackground = Color(.systemGray6)
        static let textPrimary = Color.black
        static let textSecondary = Color.gray
        static let error = Color.red
        static let primaryBlue = UIColor.systemBlue
        static let backgroundWhite = UIColor.white
        static let textColor = UIColor.black
        static let success = UIColor.green
    }

    // Fonts
    struct Fonts {
        static let largeTitle = Font.largeTitle.bold()
        static let headline = Font.headline
        static let subheadline = Font.subheadline
        static let body = Font.body
        static let footnote = Font.footnote
        static func titleFont(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .bold)
        }

        static func bodyFont(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }

    // Spacing
    struct Spacing {
        static let vertical: CGFloat = 20
        static let horizontal: CGFloat = 10
        static let inputPadding: CGFloat = 12
    }

    // Corner Radius
    struct Corners {
        static let rounded: CGFloat = 65
    }

    // Image Sizes
    struct ImageSizes {
        static let brainIcon = CGSize(width: 60, height: 65)
        static let socialIcon = CGSize(width: 40, height: 40)
    }
}
