import SwiftUI

struct Fonts {
    static func primary(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }

    static func secondary(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static let title: Font = .system(size: 24, weight: .bold)
    static let body: Font = .system(size: 16, weight: .regular)
    static let caption: Font = .system(size: 14, weight: .light)
}
