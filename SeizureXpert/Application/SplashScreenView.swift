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
                    Image("LogoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .opacity(opacity)

                    Text("SeizureXpert")
                        .font(Fonts.title)
                        .foregroundColor(.white)
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
