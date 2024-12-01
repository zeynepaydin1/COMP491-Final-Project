import SwiftUI

struct LoginView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isPasswordHidden: Bool = true
    @EnvironmentObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 25) { // Adjust spacing for consistent gaps
                Spacer().frame(height: 20)

                // Title
                Text("Hello!")
                    .font(DesignSystem.Fonts.largeTitle)
                    .foregroundColor(DesignSystem.Colors.primary)

                Text("Welcome to SeizureXpert.")
                    .font(DesignSystem.Fonts.headline)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                // Brain Icon
                Image(systemName: "brain.filled.head.profile")
                    .resizable()
                    .frame(width: DesignSystem.ImageSizes.brainIcon.width, height: DesignSystem.ImageSizes.brainIcon.height)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .padding(.top, 10)

                // Input Fields
                VStack(spacing: 12) { // Reduce spacing between fields
                    InputField(label: "Email or Mobile Number", placeholder: "example@example.com", text: $emailText)
                        .keyboardType(.emailAddress)

                    SecureInputField(label: "Password", placeholder: "********", text: $passwordText, isHidden: $isPasswordHidden)
                }

                // Forgot Password Link
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle Forgot Password
                    }) {
                        Text("Forgot Password?")
                            .font(DesignSystem.Fonts.footnote)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
                .padding(.top, 8) // Slight padding for separation

                // Log In Button
                Button(action: {
                    viewModel.login(withEmail: emailText, password: passwordText)
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DesignSystem.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(DesignSystem.Corners.rounded)
                }
                .padding(.top, 16) // Ensure button is slightly separated
                .padding(.horizontal, DesignSystem.Spacing.horizontal)

                // Divider for Social Login Options
                VStack(spacing: 10) {
                    Text("or")
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    HStack(spacing: 20) {
                        SocialLoginButton(icon: "globe", action: { /* Handle Google Login */ })
                        SocialLoginButton(icon: "f.square.fill", action: { /* Handle Facebook Login */ })
                        SocialLoginButton(icon: "touchid", action: { /* Handle Touch ID Login */ })
                    }
                }
                .padding(.top, 16)

                Spacer()

                // Sign-Up Navigation
                HStack {
                    Text("Don’t have an account?")
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    NavigationLink(destination: SignUpView().environmentObject(viewModel)) {
                        Text("Sign Up")
                            .foregroundColor(DesignSystem.Colors.primary)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 8) // Minimal padding for separation
            }
            .padding(.horizontal, DesignSystem.Spacing.horizontal) // Global padding for the whole VStack
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)

        }
        .navigationBarBackButtonHidden(true)

        if let error = viewModel.error {
            Text(error)
                .foregroundColor(.red)
                .padding(.top)
        }

    }
    
}


// Preview for LoginView
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
