import SwiftUI

struct MySamplePatientsView: View {
    @StateObject private var viewModel = MySamplePatientsViewModel()

    var body: some View {
        VStack {
            Text("My Patients")
                .font(Fonts.title)
                .foregroundColor(Colors.textPrimary)
                .padding()

            List(viewModel.myPatients) { patient in
                HStack {
                    Image(patient.profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(patient.name)
                            .font(Fonts.body)
                            .foregroundColor(Colors.textPrimary)
                        Text("Progress: \(Int(patient.progress * 100))%")
                            .font(Fonts.caption)
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2, x: 0, y: 2)
            }
            .listStyle(PlainListStyle())
        }
        .background(Colors.background.ignoresSafeArea())
    }
}

struct MySamplePatientsView_Previews: PreviewProvider {
    static var previews: some View {
        MySamplePatientsView()
    }
}
