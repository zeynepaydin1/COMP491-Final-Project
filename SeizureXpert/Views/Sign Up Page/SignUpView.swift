import SwiftUI

struct SignUpView: View {
    @State private var usernameText: String = ""
    @State private var passwordText: String = ""
    @State private var emailText: String = ""
    @State private var name: String = ""
    @State private var isDoctor: Bool = false
    @State private var showSuccessMessage = false // State to control success message
    @State private var navigateToLogin = false // State to control navigation
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.vertical) {
                Spacer().frame(height: DesignSystem.Spacing.vertical)

                // Title Section
                VStack(spacing: 5) {
                    Text("Welcome!")
                        .font(DesignSystem.Fonts.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primary)

                    Text("Sign Up to SeizureXpert.")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // Icon Section
                Image(systemName: "brain.filled.head.profile")
                    .resizable()
                    .frame(width: DesignSystem.ImageSizes.brainIcon.width, height: DesignSystem.ImageSizes.brainIcon.height)
                    .foregroundColor(DesignSystem.Colors.primary)

                // Input Fields Section
                VStack(spacing: DesignSystem.Spacing.vertical) {
                    // Doctor Toggle
                    Toggle(isOn: $isDoctor) {
                        Text("I am a doctor.")
                            .font(DesignSystem.Fonts.subheadline)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: DesignSystem.Colors.primary))
                    .padding(.horizontal, 20)

                    InputField(label: "Email", placeholder: "Enter email", text: $emailText)
                        .keyboardType(.emailAddress)

                    InputField(label: "Username", placeholder: "Enter username", text: $usernameText)

                    InputField(label: "Name and Surname", placeholder: "Enter name and surname", text: $name)
                        .autocapitalization(.words)

                    SecureInputField(label: "Password", placeholder: "************", text: $passwordText, isHidden: .constant(true))
                }

                // Sign-Up Button
                Button(action: {
                    viewModel.signUp(email: emailText, password: passwordText, username: usernameText, isDoctor: isDoctor, name: name)
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .padding(DesignSystem.Spacing.inputPadding)
                        .frame(maxWidth: .infinity)
                        .background(DesignSystem.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(DesignSystem.Corners.rounded)
                }
                .padding(.horizontal, DesignSystem.Spacing.horizontal)
                .padding(.top, DesignSystem.Spacing.vertical)

                // Success Message
                if showSuccessMessage {
                    Text("Sign up successful! Directing to Log in page...")
                        .font(DesignSystem.Fonts.subheadline)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.top, DesignSystem.Spacing.vertical)
                }

                // Login Navigation Section
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Button(action: {
                        navigateToLogin = true // Manually trigger navigation
                    }) {
                        Text("Log in!")
                            .foregroundColor(DesignSystem.Colors.primary)
                            .fontWeight(.bold)
                    }
                }

                // NavigationLink for actual navigation
                NavigationLink(
                    destination: LoginView().environmentObject(viewModel),
                    isActive: $navigateToLogin
                ) {
                    EmptyView()
                }


                Spacer()

                // Error Message
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(DesignSystem.Colors.error)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.horizontal) // Consistent horizontal padding
            .padding(.top, DesignSystem.Spacing.vertical) // Padding at the top
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .onChange(of: viewModel.signupSuccessful) { success in
                if success {
                    showSuccessMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showSuccessMessage = false
                        navigateToLogin = true // Trigger navigation after delay
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview for SignUpView
#Preview {
    SignUpView()
        .environmentObject(LoginViewModel())
}
