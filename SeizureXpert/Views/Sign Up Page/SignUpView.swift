//
//  ContentView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 10.01.2024.
//
import SwiftUI
struct SignUpView: View {
    @State private var usernameText: String = ""
    @State private var passwordText: String = ""
    @State private var emailText: String = ""
    @State private var name: String = ""
    @State private var isLecturer: Bool = false
    @StateObject private var viewModel = SignUpViewModel()
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                BackgroundDS(color1: .cyan, color2: .white)
                Circle()
                    .scale(1.56)
                    .foregroundColor(.blue)
                Circle()
                    .scale(2)
                    .foregroundColor(.blue.opacity(0.15))
                VStack {
                    Spacer()
                    Image(systemName: "person.crop.square")
                        .font(.system(size: 100))
                        .foregroundStyle(.purple)

                    VStack(spacing: -5) {
                        Heading1TextWhite(text: "Welcome!")
                            .padding()
                        Heading1TextWhite(text: "Sign Up to KUTeach")
                    }
                    VStack(spacing: -8) {
                        Toggle(isOn: $isLecturer) {
                            Text("I am a lecturer.")
                                .foregroundColor(.white)
                        }
                        .padding()
                        Rectangle()
                            .frame(width: 360, height: 1)
                            .foregroundColor(.white)
                    }
                    VStack(spacing: -5) {
                        TextFieldDSWhite(text: $emailText, placeholder: "Enter email")
                            .padding()
                        TextFieldDSWhite(text: $usernameText, placeholder: "Enter username").padding()
                        TextFieldDSWhite(text: $name, placeholder: "Enter name and surname").padding()
                        SecureFieldDSWhite(text: $passwordText, placeholder: "Enter password")
                            .padding()
                        NavigationLink(destination: LoginView(), isActive:
                                        $viewModel.signupSuccessful) {
                            EmptyView()}
                        ButtonDS(buttonTitle: "Sign Up", action: {
                            viewModel.signUp(email: emailText, password: passwordText, username:
                                                usernameText, isLecturer: isLecturer, name: name)
                        }).padding()
                        NavigationLink(destination: LoginView()) {
                            LinkText(text: "Already have an account? Log in!")
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    SignUpView().environmentObject(LoginViewModel())
}
