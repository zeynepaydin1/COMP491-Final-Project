import SwiftUI

struct PlaceholderTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.label // Regular text color
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress

        // Set placeholder color
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
