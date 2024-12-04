import SwiftUI

struct AddPatientView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Female"

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 20) {
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



            Button(action: {
                FirestoreUtility.addPatient(
                    SamplePatient(
                        id: UUID().uuidString,
                        name: name,
                        surname: surname,
                        age: age,
                        gender: gender
                    )
                ) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Failed to add patient.")
                    }
                }
            }) {
                Text("Add Patient")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Colors.primary)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView()
            .previewLayout(.sizeThatFits) // Optional: Adjust the layout for better preview
            .padding()
    }
}

