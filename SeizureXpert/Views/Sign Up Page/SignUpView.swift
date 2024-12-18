import SwiftUI

struct SignUpView: View {
    @State private var usernameText: String = ""
    @State private var passwordText: String = ""
    @State private var emailText: String = ""
    @State private var name: String = ""
    @State private var isDoctor: Bool = false
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var showSuccessMessage = false
    @State private var navigateToLogin = false
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isPasswordHidden: Bool = true


    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)

                // Title Section
                VStack(spacing: 5) {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .foregroundColor(.blue)

                    Text("Sign Up to SeizureXpert.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                // Profile Picture Section
                VStack {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            .onTapGesture {
                                showImagePicker = true
                            }
                    } else {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color.blue.opacity(0.3))
                            .overlay(
                                VStack {
                                    Image(systemName: "camera")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                    Text("Add Photo")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            )
                            .onTapGesture {
                                showImagePicker = true
                            }
                    }
                }

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
                    viewModel.signUp(
                        email: emailText,
                        password: passwordText,
                        username: usernameText,
                        isDoctor: isDoctor,
                        name: name,
                        profileImage: profileImage
                    )
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DesignSystem.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(DesignSystem.Corners.rounded)
                }.padding(.top, 16) // Ensure button is slightly separated
                    .padding(.horizontal, DesignSystem.Spacing.horizontal)


                // Success Message
                if showSuccessMessage {
                    Text("Sign-up successful! Welcome to SeizureXpert.")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top)
                }



                // Already Have an Account Section
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)

                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Log in!")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }

                // Navigation Link to Login View
                NavigationLink(
                    destination: LoginView().environmentObject(viewModel),
                    isActive: $navigateToLogin
                ) {
                    EmptyView()
                }

                // Error Message
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.horizontal) // Global padding for the whole VStack
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profileImage)
            }
            .onChange(of: viewModel.signupSuccessful) { success in
                if success {
                    showSuccessMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showSuccessMessage = false
                        navigateToLogin = true // Automatically navigate to Login after success
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}


// Preview for SignUpView
#Preview {
    SignUpView()
        .environmentObject(LoginViewModel())
}
