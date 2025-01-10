import SwiftUI

struct AnalysisCellView: View {
    var patient: SamplePatient
    var onInfoTapped: () -> Void
    var onVisualizeTapped: () -> Void

    var body: some View {
        HStack {
            // Patient Details
            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(Fonts.primary(size: 16, weight: .bold))
                    .foregroundColor(Colors.textPrimary)
                    .lineLimit(1)

//                Text("Progress: 50%") // Replace "50%" with dynamic progress if available
//                    .font(Fonts.caption)
//                    .foregroundColor(Colors.textSecondary)
                Image(systemName: "waveform.path.ecg") // Default image on error
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }

            Spacer()

            //Info and Visualize Buttons
            VStack(spacing: 8) {
                ZStack {
                    Button(action: {
                        print("Info tapped for \(patient.name)")
                        onInfoTapped()
                    }) {
                        Text("Info")
                            .font(Fonts.body)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: 40)

                ZStack {
                    Button(action: {
                        print("Visualize tapped for \(patient.name)")
                        onVisualizeTapped()
                    }) {
                        Text("Visualize")
                            .font(Fonts.body)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Colors.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: 40)
            }
            .frame(width: 100)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.medium))
        .shadow(radius: 2, x: 0, y: 2)
        .contentShape(Rectangle())
    }
}
