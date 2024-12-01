//
//  DisableAutofillTextField.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 11/21/24.
//

import Foundation
import SwiftUI

struct DisableAutofillTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DisableAutofillTextField
        init(parent: DisableAutofillTextField) {
            self.parent = parent
        }
    }

    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .oneTimeCode // This prevents iOS autofill
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
}
