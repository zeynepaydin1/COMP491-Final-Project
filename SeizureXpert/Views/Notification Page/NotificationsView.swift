import SwiftUI

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view

    var body: some View {
        ZStack {
            Colors.background // Background color from the design system
                .ignoresSafeArea()

            VStack {
                Spacer()
                Components.label(text: "Notifications", font: Fonts.title, textColor: Colors.primary)
                    .padding(.bottom, Dimensions.Spacing.large)

                Components.button(title: "Back to Home", backgroundColor: Colors.primary) {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
                .frame(width: 200, height: 50)

                Spacer()
            }
        }
    }
}

#Preview {
    NotificationsView()
}
