import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode // To handle back navigation

    var body: some View {
        ZStack {
            Colors.background // Background from the design system
                .ignoresSafeArea()

            VStack(spacing: Dimensions.Spacing.large) {
                Components.label(text: "Profile", font: Fonts.title, textColor: Colors.primary)

                Components.button(title: "Back to Home", backgroundColor: Colors.primary) {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
                .frame(width: 200, height: 50)
            }
        }
    }
}
