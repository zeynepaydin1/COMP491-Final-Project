import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0

    var body: some View {
        if isActive {
            HomeScreenView() // Transition to your main view
        } else {
            ZStack {
                Colors.primary // Background color from Design System
                    .ignoresSafeArea()

                VStack {
                    Image("LogoBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(opacity)

                    Text("Seizure Xpert")
                        .font(Fonts.title)
                        .foregroundColor(Colors.textSecondary)
                        .opacity(opacity)
                }
            }
            .onAppear {
                performSplashAnimation()
            }
        }
    }

    private func performSplashAnimation() {
        withAnimation(.easeIn(duration: 2)) {
            opacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isActive = true
        }
    }
}

#Preview {
    SplashScreenView()
}
