import SwiftUI

struct Components {
    static func button(title: String, backgroundColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Fonts.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(Dimensions.CornerRadius.medium)
        }
    }

    static func label(text: String, font: Font, textColor: Color = Colors.textPrimary) -> some View {
        Text(text)
            .font(font)
            .foregroundColor(textColor)
    }
}
