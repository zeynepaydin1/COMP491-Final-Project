import SwiftUI

struct VisualizationView: View {
    let patient: SamplePatient

    var body: some View {
        VStack {
            
         
            // Patient Profile Information
            HStack {
                Image("female_patient")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(patient.name + " " + patient.surname)
                        .font(Fonts.primary(size: 20, weight: .bold))
                        .foregroundColor(Colors.textPrimary)
                    Text(patient.age + " | " + patient.gender)
                        .font(Fonts.body)
                        .foregroundColor(Colors.textSecondary)
                }
                Spacer()
            }
            .padding()

            Divider()

        
            // Visualization Grid (3 Rows x 2 Columns with Unique Text)
              VStack(spacing: 32) {
                  HStack(spacing: 32) {
                      Button(action: {
                          print("Button 1 tapped")
                      }) {
                          Text("Visualise 2D Seizure Onset Zones")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                      Button(action: {
                          print("Button 2 tapped")
                      }) {
                          Text("Visualise 3D Seizure Onset Zones")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                  }

                  HStack(spacing: 32) {
                      Button(action: {
                          print("Button 3 tapped")
                      }) {
                          Text("Retrieve High-Frequency Oscillations")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                      Button(action: {
                          print("Button 4 tapped")
                      }) {
                          Text("Generate Heatmap")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                  }

                  HStack(spacing: 32) {
                      Button(action: {
                          print("Button 5 tapped")
                      }) {
                          Text("Display Raw EEG Frequency")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                      Button(action: {
                          print("Button 6 tapped")
                      }) {
                          Text("Generate GPT Report")
                              .font(.headline)
                              .foregroundColor(Colors.primary)
                              .frame(width: 100, height: 100)
                              .padding()
                              .background(.white)
                              .cornerRadius(8)
                              .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                      }
                  }
              }
              .padding()

            Spacer()
            
        }
        .padding()
        .background(Colors.background.ignoresSafeArea())
        .navigationBarTitle("Visualization", displayMode: .inline)
    }
}





// Preview for VisualizationView
struct VisualizationView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPatient = SamplePatient(id: "", name: "Jane", surname: "Doe", age: "30", gender: "female", profileImageURL: "") // Sample patient data
        
        VisualizationView(patient: mockPatient)
            .previewDisplayName("Visualization View")
    }
}
