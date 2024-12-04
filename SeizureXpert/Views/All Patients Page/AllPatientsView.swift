import SwiftUI

struct AllPatientsView: View {
    @StateObject private var viewModel = AllPatientsViewModel()

    var body: some View {
        VStack {
            Text("All Patients")
                .font(Fonts.title)
                .foregroundColor(Colors.textPrimary)
                .padding()

            if viewModel.allPatients.isEmpty {
                Text("No patients available. Please add new patients.")
                    .font(Fonts.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.allPatients) { patient in
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
                            Text("Progress: 50%")
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
        }
        .onAppear {
            viewModel.fetchAllPatients()
        }
        .background(Colors.background.ignoresSafeArea())
    }
}

struct AllPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        AllPatientsView()
    }
}
