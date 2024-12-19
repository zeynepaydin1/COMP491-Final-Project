import SwiftUI

struct AddPatientView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Female"
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var successMessage: String?
    @State private var errorMessage: String?

    @StateObject private var viewModel = AddPatientViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel // To retrieve the username of the logged-in user

    var body: some View {
        VStack(spacing: 20) {
            Text("Register Yourself")
                .font(.title2)
                .foregroundColor(Colors.primary)
                .padding()

            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding(.horizontal)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding(.horizontal)
            }

            Button(action: {
                isImagePickerPresented = true
            }) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                } else if let username = loginViewModel.currentUser?.username {
                    ProfileImageView(username: username)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $profileImage)
            }


            InputField(label: "", placeholder: "Name", text: $name)
                .keyboardType(.emailAddress)

            InputField(label: "", placeholder: "Surname", text: $surname)
                .keyboardType(.emailAddress)

            InputField(label: "", placeholder: "Age", text: $age)
                .keyboardType(.numberPad)


            Picker("Gender", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: {
                addPatient()
            }) {
                Text("Register")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(DesignSystem.Corners.rounded)
            }
            .padding(.top, 16) // Ensure button is slightly separated
            .padding(.horizontal, DesignSystem.Spacing.horizontal)

            Spacer()

            Button(action: {
                loginViewModel.logout { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Colors.background)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func addPatient() {
        successMessage = nil
        errorMessage = nil

        guard let username = loginViewModel.currentUser?.username else {
            errorMessage = "Failed to retrieve username. Please log in again."
            return
        }

        let patient = SamplePatient(
            id: UUID().uuidString,
            name: name,
            surname: surname,
            age: age,
            gender: gender,
            username: username // Use the username from the logged-in user
        )

        viewModel.addPatient(patient: patient, profileImage: profileImage) { success in
            if success {
                successMessage = "You have registered successfully!"
            } else {
                errorMessage = viewModel.error ?? "Failed to register. Please try again."
            }
        }
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        let loginViewModel = LoginViewModel()
        loginViewModel.currentUser = User(username: "john_doe", email: "john@example.com", name: "John Doe", isDoctor: false)

        return AddPatientView()
            .environmentObject(loginViewModel) // Provide the environment object required by the view
    }
}
