//
//  Styles.swift
//  SeizureXpert
//
//  Created by B50 on 29.11.2024.
//

import Foundation
import UIKit

struct DesignSystem {
    struct Colors {
        static let primaryBlue = UIColor.systemBlue
        static let backgroundWhite = UIColor.white
        static let textColor = UIColor.black
    }

    struct Fonts {
        static func titleFont(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .bold)
        }

        static func bodyFont(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
}
