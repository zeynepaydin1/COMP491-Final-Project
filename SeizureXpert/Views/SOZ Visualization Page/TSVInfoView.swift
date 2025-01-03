import SwiftUI

struct TSVInfoView: View {
    @ObservedObject var viewModel: ChannelListViewModel

    var body: some View {
        ZStack {
            // 1) Subtle Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGroupedBackground),
                    Color.blue.opacity(0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                if let result = viewModel.predictionResult {
                    // 2) Title
                    Text("Prediction Results")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.primary)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)

                    // 3) Card-Like Container
                    VStack(spacing: 16) {
                        infoRow(label: "Label", value: result.predictedLabel)
                        infoRow(label: "Probability F", value: String(format: "%.4f", result.probabilityF))
                        infoRow(label: "Probability S", value: String(format: "%.4f", result.probabilityS))

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground).opacity(0.9))
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)

                } else {
                    // 4) No Data View
                    Text("No TSV data found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("TSV Info")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// A small helper to create a stylish info row
    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.clear)
    }
}
