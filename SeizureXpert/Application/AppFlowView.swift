import SwiftUI

struct AppFlowView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var showSplashScreen = true

    var body: some View {
        Group {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                        // Show the splash screen for 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplashScreen = false
                        }
                    }
            } else if !loginViewModel.loginSuccessful {
                // Show LoginView after SplashScreen
                LoginView()
            } else {
                // Show HomeScreenView after successful login
                loginViewModel.destinationView
            }
        }
        .animation(.easeInOut, value: showSplashScreen)
    }
}
