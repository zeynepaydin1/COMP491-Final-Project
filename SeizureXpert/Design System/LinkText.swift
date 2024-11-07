//
//  LinkText.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import SwiftUI
struct LinkText: View {
    let text: String
    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(.white)
    }
}
#Preview {
    LinkText(text: "Test")
}
