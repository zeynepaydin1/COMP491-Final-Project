import SwiftUI

struct AddPatientView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Female"
    @State private var progress: Float = 0.0 // Allow setting progress

    var onAddPatient: (SamplePatient) -> Void

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

            Slider(value: $progress, in: 0.0...1.0, step: 0.01) {
                Text("Progress: \(Int(progress * 100))%")
            }
            .padding()

            Button(action: {
                let newPatient = SamplePatient(
                    id: UUID().uuidString,
                    name: name,
                    surname: surname,
                    age: age,
                    gender: gender,
                    progress: progress
                )
                onAddPatient(newPatient)
                FirestoreUtility.addPatient(newPatient) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
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
        AddPatientView { newPatient in
            print("Patient added: \(newPatient.name) \(newPatient.surname), Gender: \(newPatient.gender), Progress: \(newPatient.progress)")
        }
    }
}
