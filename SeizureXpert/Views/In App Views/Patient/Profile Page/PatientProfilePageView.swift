//
//  PatientProfilePageView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct PatientProfilePageView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @StateObject private var viewModel = PatientProfilePageViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var shouldNavigateToSignUp = false
    @State private var errorMessage: String = ""
    @State private var showingError: Bool = false
    var user: User
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundDS(color1: .cyan, color2: .white)
                VStack(spacing: 40) {
                    HStack(spacing: 30) {
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .frame(width: 75, height: 75)
                        Heading1TextBlack(text: user.name)
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1, x: 3, y: 3)
                    }
                    HStack {
                        BodyText(text: "Patient username: \(user.username)")
                    }
                    .padding(.leading, -150)
                    .frame(width: 350, height: 50)
                    .background(Color.white)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1, x: 3, y: 3)
                    HStack {
                        BodyText(text: "Email: \(user.email)")
                    }.padding(.leading, -150)
                        .frame(width: 350, height: 50)
                        .background(Color.white)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1, x: 3, y: 3)
                }
                .padding(.top, -325)
                .padding(.horizontal, -175)
                VStack(spacing: 20) {
                    Heading1TextBlack(text: "Change Password")
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1, x: 3, y: 3)
                    SecureFieldDSBlack(text: $oldPassword, placeholder: "Enter old password")
                        .frame(width: 300)
                    SecureFieldDSBlack(text: $newPassword, placeholder: "Enter new password")
                        .frame(width: 300)
                    ButtonDS(buttonTitle: "Change now!") {
                        loginViewModel.changePassword(currentEmail: user.email,
                                                      oldPassword: oldPassword, newPassword: newPassword) { success in
                            if success {
                                print("Password successfully updated")
                            } else {
                                errorMessage = "Failed to update password: \(loginViewModel.error ?? "Unknown error")"
                                showingError = true
                            }
                        }
                    }
                    ButtonDS(buttonTitle: "Logout", action: {
                        loginViewModel.logout { success in
                            if success {
                                print("Successfully logged out")
                                self.shouldNavigateToSignUp = true
                            } else {
                                errorMessage = "Logout failed"
                                showingError = true
                            }
                        }
                    })
                }.padding(.top, 250)
                NavigationLink(destination: SignUpView(), isActive: $shouldNavigateToSignUp) {
                    EmptyView()
                }
                if showingError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1, x: 3, y: 3)
                        .onTapGesture {
                            showingError = false
                        }
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    PatientProfilePageView(user: User(username: "test",
                                      email: "test", name: "test", isDoctor: false))
    .environmentObject(LoginViewModel())
}
