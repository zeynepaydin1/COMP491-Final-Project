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
                    Text(patient.name)
                        .font(Fonts.primary(size: 20, weight: .bold))
                        .foregroundColor(Colors.textPrimary)
                    Text("Progress: 50%")
                        .font(Fonts.body)
                        .foregroundColor(Colors.textSecondary)
                }
                Spacer()
            }
            .padding()

            Divider()

            // Visualization Content
            Text("Seizure Onset Zone Visualization")
                .font(Fonts.title)
                .foregroundColor(Colors.textPrimary)
                .padding()

            Spacer()

            // Add visualization components here (e.g., graphs, charts, images)
            Rectangle()
                .fill(Colors.primary.opacity(0.3))
                .frame(height: 300)
                .cornerRadius(Dimensions.CornerRadius.medium)
                .overlay(
                    Text("Visualization Data Here")
                        .font(Fonts.caption)
                        .foregroundColor(Colors.textSecondary)
                )

            Spacer()

            // Back Button
            Button(action: {
                // Handle back navigation
            }) {
                Text("Back")
                    .font(Fonts.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(Dimensions.CornerRadius.medium)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Colors.background.ignoresSafeArea())
        .navigationBarTitle("Visualization", displayMode: .inline)
    }
}
