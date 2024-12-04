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

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel // To handle logout

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Register Yourself")
                .font(.title2)
                .foregroundColor(Colors.primary)
                .padding()

            // Success or Error Message
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

            // Profile Image Picker
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
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $profileImage)
            }

            // Input Fields
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Surname", text: $surname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Age", text: $age)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Gender", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Add Patient Button
            Button(action: {
                addPatient()
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Colors.primary)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()

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
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Colors.background)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    // Function to Add Patient
    private func addPatient() {
        successMessage = nil
        errorMessage = nil

        guard let profileImage = profileImage else {
            errorMessage = "Please upload a profile picture."
            return
        }

        print("Starting image upload...") // Debug Log

        // Upload profile image to Firebase Storage and get the URL
        FirestoreUtility.uploadProfileImage(profileImage) { result in
            switch result {
            case .success(let imageURL):
                print("Successfully uploaded image. URL: \(imageURL)") // Debug Log
                // Save patient data to Firestore
                FirestoreUtility.addPatient(
                    SamplePatient(
                        id: UUID().uuidString,
                        name: name,
                        surname: surname,
                        age: age,
                        gender: gender,
                        profileImageURL: imageURL
                    )
                ) { success in
                    if success {
                        successMessage = "You have registered successfully!"
                        print("Patient added with profileImageURL: \(imageURL)") // Debug Log
                    } else {
                        errorMessage = "Failed to register. Please try again."
                    }
                }
            case .failure(let error):
                errorMessage = "Failed to upload profile image: \(error.localizedDescription)"
                print(errorMessage) // Debug Log
            }
        }
    }
}
