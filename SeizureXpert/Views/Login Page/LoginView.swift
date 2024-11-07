//
//  LoginView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import SwiftUI
struct LoginView: View {
    @State private var usernameText: String = ""
    @State private var passwordText: String = ""
    @State private var emailText: String = ""
    @EnvironmentObject var viewModel: LoginViewModel
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                BackgroundDS(color1: .cyan, color2: .white)
                Circle()
                    .scale(1.5)
                    .foregroundColor(.blue)
                Circle()
                    .scale(2)
                    .foregroundColor(.blue.opacity(0.15))
                VStack {
                    Spacer()
                    Image(systemName: "person.crop.square")
                        .font(.system(size: 100))
                        .foregroundStyle(.purple)
                    Heading1TextWhite(text: "Welcome!")
                        .padding()
                    Heading1TextWhite(text: "Login to KUTeach")
                    TextFieldDSWhite(text: $emailText, placeholder: "Enter email")
                        .padding()
                    SecureFieldDSWhite(text: $passwordText, placeholder: "Enter password")
                        .padding()
                    NavigationLink(destination: viewModel.destinationView,
                                   isActive: $viewModel.loginSuccessful) {EmptyView()}
                    ButtonDS(buttonTitle: "Login", action: {
                        viewModel.login(withEmail: emailText, password: passwordText)
                    })
                    Spacer()
                    Spacer()
                    Spacer()
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }.onAppear {
                viewModel.error = nil
            }
        }.navigationBarBackButtonHidden(viewModel.loginSuccessful)
    }
}
#Preview {
    LoginView().environmentObject(LoginViewModel())
}
