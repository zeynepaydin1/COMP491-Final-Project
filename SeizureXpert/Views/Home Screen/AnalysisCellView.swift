import SwiftUI

struct AnalysisCellView: View {
    var patient: SamplePatient
    var onInfoTapped: () -> Void
    var onVisualizeTapped: (() -> Void)?

    var body: some View {
        HStack {
            // Profile Image
            Image("female_patient")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading)

            // Patient Details
            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(Fonts.primary(size: 16, weight: .bold))
                    .foregroundColor(Colors.textPrimary)
                    .lineLimit(1) // Ensures the name doesn't overflow

                Text("50%")
                    .font(Fonts.caption)
                    .foregroundColor(Colors.textSecondary)
            }

            Spacer()

            // Action Buttons
            VStack(spacing: 8) { // Adjust spacing between buttons if needed
                Button(action: onInfoTapped) {
                    Text("Info")
                        .font(Fonts.body)
                        .padding(8)
                        .frame(maxWidth: .infinity) // Makes the button's width consistent
                        .background(Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if let onVisualizeTapped = onVisualizeTapped {
                    Button(action: onVisualizeTapped) {
                        Text("Visualize")
                            .font(Fonts.body)
                            .padding(8)
                            .frame(maxWidth: .infinity) // Makes the button's width consistent
                            .background(Colors.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .frame(width: 100) // Adjust button container width as needed
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.medium))
        .shadow(radius: 2, x: 0, y: 2)
    }
}
