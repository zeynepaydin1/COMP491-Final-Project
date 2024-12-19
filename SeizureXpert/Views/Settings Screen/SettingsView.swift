import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                // Profile Picture Section
                VStack {
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
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
                    }
                }
                .onTapGesture {
                    viewModel.showImagePicker = true
                }

                // Success or Error Message
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.headline)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                }

                // Progress View
                if viewModel.isUploading {
                    VStack {
                        Text("Uploading: \(Int(viewModel.uploadProgress * 100))%")
                            .font(.headline)
                            .padding(.bottom, 10)

                        ProgressView(value: viewModel.uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding(.horizontal)
                    }
                }

                // Upload Button
                Button(action: {
                    if let username = loginViewModel.currentUser?.username {
                        viewModel.uploadProfileImage(for: username)
                    }
                }) {
                    Text("Upload Profile Picture")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedImage != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .disabled(viewModel.selectedImage == nil)

                // Sign Out Button
                Button(action: {
                    loginViewModel.logout { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }

                Spacer()
            }
            .padding()
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
        }
    }
}


// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let loginViewModel = LoginViewModel()
        loginViewModel.currentUser = User(username: "zeynepdoctor", email: "zeynep@example.com", name: "Zeynep", isDoctor: true)
        return SettingsView().environmentObject(loginViewModel)
            .previewDisplayName("Settings View Preview")
    }
}
