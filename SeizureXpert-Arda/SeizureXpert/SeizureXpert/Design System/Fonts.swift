import UIKit

struct Fonts {
    static func primary(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    static func secondary(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }

    static let title = primary(size: 24, weight: .bold)
    static let body = primary(size: 16)
    static let caption = primary(size: 14, weight: .light)
}
