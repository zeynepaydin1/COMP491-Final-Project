import SwiftUI

struct DoctorProfileView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("doctor")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.leading)

            VStack(alignment: .leading, spacing: 4) {
                Text("Dr. Sarah Lee")
                    .font(Fonts.title)
                    .foregroundColor(Colors.textPrimary)
                Text("Neurologist | EEG Specialist")
                    .font(Fonts.body)
                    .foregroundColor(Colors.textSecondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.medium))
        .shadow(radius: 2, x: 0, y: 2)
    }
}
