import UIKit

struct Components {
    static func createButton(title: String, backgroundColor: UIColor, action: Selector, target: Any) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = Fonts.body
        button.layer.cornerRadius = 10
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createLabel(text: String, font: UIFont, textColor: UIColor = Colors.textPrimary) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
